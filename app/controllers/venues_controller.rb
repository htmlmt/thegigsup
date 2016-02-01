class VenuesController < ApplicationController
  before_action :set_venue, only: [:show, :edit, :update, :destroy]

  # GET /venues
  # GET /venues.json
  def index
    @venues = Venue.all
  end

  # GET /venues/1
  # GET /venues/1.json
  def show
      events = @venue.events.order(:start)
      
      if params[:month] && params[:year]
          dateString = params[:month] + ' ' + params[:year]
          @month = Time.parse(dateString)
          
          events = @venue.events.where("start >= ? AND start <= ?", @month.beginning_of_month.in_time_zone, @month.end_of_month.in_time_zone).order(:start)
      else
          @month = Time.now.in_time_zone
          events = @venue.events.where("start >= ? AND start <= ?", @month, Time.now.in_time_zone.end_of_month).order(:start)
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

  # GET /venues/new
  def new
    @venue = Venue.new
  end

  # GET /venues/1/edit
  def edit
  end

  # POST /venues
  # POST /venues.json
  def create
    @venue = Venue.new(venue_params)

    respond_to do |format|
      if @venue.save
        format.html { redirect_to @venue, notice: 'Venue was successfully created.' }
        format.json { render :show, status: :created, location: @venue }
      else
        format.html { render :new }
        format.json { render json: @venue.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /venues/1
  # PATCH/PUT /venues/1.json
  def update
    respond_to do |format|
      if @venue.update(venue_params)
        format.html { redirect_to @venue, notice: 'Venue was successfully updated.' }
        format.json { render :show, status: :ok, location: @venue }
      else
        format.html { render :edit }
        format.json { render json: @venue.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /venues/1
  # DELETE /venues/1.json
  def destroy
    @venue.destroy
    respond_to do |format|
      format.html { redirect_to venues_url, notice: 'Venue was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_venue
      @venue = Venue.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def venue_params
      params.require(:venue).permit(:name, :city, :street, :zip, :website, :longitude, :latitude)
    end
end
