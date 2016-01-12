class EventsController < ApplicationController
    autocomplete :venue, :name, :full => true
    autocomplete :band, :name, :full => true
    
    before_action :set_event, only: [:show, :edit, :update, :destroy]
    
    def gigs
        reposts = Repost.order(:created_at)
        @gigs = []
        
        reposts.each do |repost|
            if repost.event.start > Time.now
                if repost.event.poster.exists?
                    @gigs << repost.event
                end
            end
        end
    end

    # GET /events
    # GET /events.json
    def index
        if params[:month] && params[:year]
            dateString = params[:month] + ' ' + params[:year]
            @month = Time.parse(dateString)
            
            events = Event.where("start >= ? AND start <= ?", @month.beginning_of_month, Time.parse(dateString).end_of_month).order(:start)
        else
            @month = Time.now
            events = Event.where("start >= ? AND start <= ?", @month, Time.now.end_of_month).order(:start)
        end
        
        @dates = []
    
        events.each do |event|
            unless @dates.include? event.start.beginning_of_day
                if event.start >= Time.now
                    @dates << event.start.beginning_of_day
                end
            end
        end
    end

    # GET /events/1
    # GET /events/1.json
    def show
    end

    # GET /events/new
    def new
        @event = Event.new
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
                @venue.events << @event
                repost = Repost.create()
                @event.reposts << repost
                
                bands = params[:bands].split(",")
                
                bands.each do |band|
                    band = band.strip
                end
                
                bands.each do |band|
                    if Band.find_by(name: band) == nil
                        @event.bands << Band.create(name: band)
                    else
                        @event.bands << Band.find_by(name: band)
                    end
                end
                format.html { redirect_to events_url, notice: 'Event was successfully created.' }
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
        respond_to do |format|
            if @event.update(event_params)
                format.html { redirect_to events_url, notice: 'Event was successfully updated.' }
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
