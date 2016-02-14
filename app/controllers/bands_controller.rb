class BandsController < ApplicationController
  before_action :set_band, only: [:show, :edit, :update, :destroy]
  http_basic_authenticate_with name: ENV["ADMIN_USERNAME"], password: ENV["ADMIN_PASSWORD"], except: :show

  # GET /bands
  # GET /bands.json
  def index
    @bands = Band.all
  end

  # GET /bands/1
  # GET /bands/1.json
  def show
      events = @band.events.order(:start)
      
      if params[:month] && params[:year]
          dateString = params[:month] + ' ' + params[:year]
          @month = Time.zone.parse(dateString)
          events = @band.events.where("start >= ? AND start <= ?", @month, @month.end_of_month).order(:start)
      else
          @month = Time.current
          events = @band.events.where("start >= ? AND start <= ?", @month, @month.end_of_month).order(:start)
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

  # GET /bands/new
  def new
    @band = Band.new
  end

  # GET /bands/1/edit
  def edit
  end

  # POST /bands
  # POST /bands.json
  def create
    @band = Band.new(band_params)

    respond_to do |format|
      if @band.save
        format.html { redirect_to @band, notice: 'Band was successfully created.' }
        format.json { render :show, status: :created, location: @band }
      else
        format.html { render :new }
        format.json { render json: @band.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bands/1
  # PATCH/PUT /bands/1.json
  def update
    respond_to do |format|
      if @band.update(band_params)
        format.html { redirect_to @band, notice: 'Band was successfully updated.' }
        format.json { render :show, status: :ok, location: @band }
      else
        format.html { render :edit }
        format.json { render json: @band.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bands/1
  # DELETE /bands/1.json
  def destroy
    @band.destroy
    respond_to do |format|
      format.html { redirect_to bands_url, notice: 'Band was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_band
      @band = Band.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def band_params
      params.require(:band).permit(:name, :website)
    end
end
