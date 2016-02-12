class EventsController < ApplicationController
    autocomplete :venue, :name, :full => true
    autocomplete :band, :name, :full => true
    
    before_action :set_event, only: [:show, :edit, :update, :destroy]
    
    def gigs
        reposts = Repost.order(:created_at)
        @gigs = []
        
        reposts.each do |repost|
            if repost.event.start > Time.now.in_time_zone
                if repost.event.poster.exists?
                    @gigs << repost.event
                end
            end
        end
    end
    
    def tags
        if params[:month] && params[:year]
            dateString = params[:month] + ' ' + params[:year]
            @month = Time.zone.parse(dateString)
            events = Event.where("start >= ? AND start <= ?", @month, @month.end_of_month).order(:start)
        else
            @month = Time.current
            events = Event.where("start >= ? AND start <= ?", @month, @month.end_of_month).order(:start)
        end
        
        tag_events = []
        
        events.each do |event|
            event.bands.each do |band|
                if band.tags != nil
                    if band.tags.include? params[:tag].gsub('-', ' ')
                        tag_events << event
                    end
                end
            end
        end
        
        @dates = []
        
        tag_events.each do |event|
            unless @dates.include? event.start.in_time_zone.beginning_of_day
                if event.start >= Time.now.in_time_zone
                    @dates << event.start.in_time_zone.beginning_of_day
                end
            end
        end
        
        @tag = params[:tag]
    end

    # GET /events
    # GET /events.json
    def index
        if params[:month] && params[:year]
            dateString = params[:month] + ' ' + params[:year]
            @month = Time.zone.parse(dateString)
            events = Event.where("start >= ? AND start <= ?", @month, @month.end_of_month).order(:start)
        else
            @month = Time.current
            events = Event.where("start >= ? AND start <= ?", @month, @month.end_of_month).order(:start)
        end
        
        @dates = []
    
        events.each do |event|
            unless @dates.include? event.start.in_time_zone.beginning_of_day
                if event.start >= Time.now.in_time_zone
                    @dates << event.start.in_time_zone.beginning_of_day
                end
            end
        end
    end

    # GET /events/1
    # GET /events/1.json
    def show
        @month = @event.start
    end

    # GET /events/new
    def new
        @event = Event.new
    end
    
    # GET /events/new
    def venew
        @event = Event.new
        @venue = Venue.friendly.find(params[:id])
    end

    # GET /events/1/edit
    def edit
    end

    # POST /events
    # POST /events.json
    def create
        @event = Event.new(event_params)
        
        if Venue.find_by(name: params[:venue]) == nil
            @venue = Venue.create(name: params[:venue])
        else
            @venue = Venue.find_by(name: params[:venue])
        end
        
        @bands = []
        
        respond_to do |format|
            if @event.save
                event_date_time = event_params[:start] + ' CST'
                @event.update(start: DateTime.strptime(event_date_time, '%m/%d/%Y %l:%M %p %Z'))
                @venue.events << @event
                repost = Repost.create()
                @event.reposts << repost
                
                supporting_acts = params["supporting-acts"]
                
                supporting_acts.each do |index, name|
                    name = name.strip
                    unless name == ""
                        if Band.find_by(name: name) == nil
                            @event.bands << Band.create(name: name)
                            supporting_acts = @event.supporting_acts.push(Band.find_by(name: name).id)
                            @event.update(supporting_acts: supporting_acts)
                        else
                            @band = Band.find_by(name: name)
                            band_in_lineup = false
                            @event.bands.each do |band|
                                if band.id == @band.id
                                    band_in_lineup = true
                                    break
                                end
                            end
                            if band_in_lineup == false
                                @event.bands << Band.find_by(name: name)
                                supporting_acts = @event.supporting_acts.push(Band.find_by(name: name).id)
                                @event.update(supporting_acts: supporting_acts)
                            else
                                supporting_acts = @event.supporting_acts.push(Band.find_by(name: name).id)
                                @event.update(supporting_acts: supporting_acts)
                            end
                        end
                    end
                end
                
                headliners = params["headliners"]
                
                headliners.each do |index, name|
                    name = name.strip
                    unless name == ""
                        if Band.find_by(name: name) == nil
                            @event.bands << Band.create(name: name)
                            headliners = @event.headliners.push(Band.find_by(name: name).id)
                            @event.update(headliners: headliners)
                        else
                            @band = Band.find_by(name: name)
                            band_in_lineup = false
                            @event.bands.each do |band|
                                if band.id == @band.id
                                    band_in_lineup = true
                                    break
                                end
                            end
                            if band_in_lineup == false
                                @event.bands << Band.find_by(name: name)
                                headliners = @event.headliners.push(Band.find_by(name: name).id)
                                @event.update(headliners: headliners)
                            else
                                headliners = @event.headliners.push(Band.find_by(name: name).id)
                                @event.update(headliners: headliners)
                            end
                        end
                    end
                end
                
                format.html { redirect_to @event, notice: 'Event was successfully created.' }
                format.json { render :show, status: :created, location: @event }
            else
                format.html { render :new }
                format.json { render json: @event.errors, status: :unprocessable_entity }
            end
        end
    end

    # PATCH/PUT /events/1
    # PATCH/PUT /events/1.json
    def update
        if Venue.find_by(name: params[:venue]) == nil
            @venue = Venue.create(name: params[:venue])
        else
            @venue = Venue.find_by(name: params[:venue])
        end
        
        @bands = []
        
        respond_to do |format|
            if @event.update(event_params)
                event_date_time = event_params[:start] + ' CST'
                @event.update(start: DateTime.strptime(event_date_time, '%m/%d/%Y %l:%M %p %Z'))
                
                if @venue.id != @event.venue.id
                    @event.update(venue_id: @venue.id)
                end
                
                if params["removed_supporting-acts"] != nil
                    removed_supporting_acts = params["removed_supporting-acts"]
                    
                    removed_supporting_acts.each do |index, name|
                        name = name.strip
                        unless name == ""
                            if Band.find_by(name: name) != nil
                                @band = Band.find_by(name: name)
                                @event.bands.delete(@band)
                                @event.supporting_acts.delete(@band.id)
                            end
                        end
                    end
                end
                
                if params["removed_headliners"] != nil
                    removed_headliners = params["removed_headliners"]
                    
                    removed_headliners.each do |index, name|
                        name = name.strip
                        unless name == ""
                            if Band.find_by(name: name) != nil
                                @band = Band.find_by(name: name)
                                @event.bands.delete(@band)
                                @event.headliners.delete(@band.id)
                            end
                        end
                    end
                end
                
                if params["supporting_acts"] != nil
                    supporting_acts = params["supporting_acts"]
                
                    supporting_acts.each do |index, name|
                        name = name.strip
                        unless name == ""
                            if Band.find_by(name: name) == nil
                                @band = Band.create(name: name)
                                @event.bands << @band
                            else
                                @band = Band.find_by(name: name)
                                band_in_lineup = false
                                @event.bands.each do |band|
                                    if band.id == @band.id
                                        band_in_lineup = true
                                        break
                                    end
                                end
                                if band_in_lineup == false
                                    @event.bands << @band
                                end
                            end
                        end
                    end
                    
                    @event.update(supporting_acts: [])
                    supporting_acts.each do |supporting_act|
                        supporting_acts = @event.supporting_acts.push(Band.find_by(name: supporting_act).id)
                        @event.update(supporting_acts: supporting_acts)
                    end
                end
                
                if params["headliners"] != nil
                    headliners = params["headliners"]
                
                    headliners.each do |index, name|
                        name = name.strip
                        unless name == ""
                            if Band.find_by(name: name) == nil
                                @band = Band.create(name: name)
                                @event.bands << @band
                            else
                                @band = Band.find_by(name: name)
                                band_in_lineup = false
                                @event.bands.each do |band|
                                    if band.id == @band.id
                                        band_in_lineup = true
                                        break
                                    end
                                end
                                if band_in_lineup == false
                                    @event.bands << @band
                                end
                            end
                        end
                    end
                    
                    @event.update(headliners: [])
                    headliners.each do |headliner|
                        headliners = @event.headliners.push(Band.find_by(name: headliner).id)
                        @event.update(headliners: headliners)
                    end
                end
                
                format.html { redirect_to @event, notice: 'Event was successfully updated.' }
                format.json { render :show, status: :ok, location: @event }
            else
                format.html { render :edit }
                format.json { render json: @event.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /events/1
    # DELETE /events/1.json
    def destroy
        @event.destroy
        respond_to do |format|
            format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
        @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
        params.require(:event).permit(:facebook_id, :poster, :start)
    end
end
