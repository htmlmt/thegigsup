class RepostsController < ApplicationController
  before_action :set_repost, only: [:show, :edit, :update, :destroy]
  http_basic_authenticate_with name: ENV["ADMIN_USERNAME"], password: ENV["ADMIN_PASSWORD"]

  # GET /reposts
  # GET /reposts.json
  def index
    @reposts = Repost.all
  end

  # GET /reposts/1
  # GET /reposts/1.json
  def show
  end

  # GET /reposts/new
  def new
    @repost = Repost.new
  end

  # GET /reposts/1/edit
  def edit
  end

  # POST /reposts
  # POST /reposts.json
  def create
    @repost = Repost.new(repost_params)

    respond_to do |format|
      if @repost.save
        format.html { redirect_to @repost, notice: 'Repost was successfully created.' }
        format.json { render :show, status: :created, location: @repost }
      else
        format.html { render :new }
        format.json { render json: @repost.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reposts/1
  # PATCH/PUT /reposts/1.json
  def update
    respond_to do |format|
      if @repost.update(repost_params)
        format.html { redirect_to @repost, notice: 'Repost was successfully updated.' }
        format.json { render :show, status: :ok, location: @repost }
      else
        format.html { render :edit }
        format.json { render json: @repost.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reposts/1
  # DELETE /reposts/1.json
  def destroy
    @repost.destroy
    respond_to do |format|
      format.html { redirect_to reposts_url, notice: 'Repost was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_repost
      @repost = Repost.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def repost_params
      params.require(:repost).permit(:event_id)
    end
end
