class LeagueMeetsController < ApplicationController
  before_action :set_league_meet, only: [:show, :edit, :update, :destroy]

  # GET /league_meets
  # GET /league_meets.json
  def index
    @league_meets = LeagueMeet.all.order( 'date DESC' )
  end

  # GET /league_meets/1
  # GET /league_meets/1.json
  def show
      if(!params[:name])
          respond_to do |format|
              format.html { redirect_to fullmeet_path(:name=>@league_meet.name.gsub(" ","_")) }
          end
          return
          # render :search
          # return
      end

  end

  # GET /league_meets/new
  def new
    @league_meet = LeagueMeet.new
  end

  # GET /league_meets/1/edit
  def edit
  end

  # POST /league_meets
  # POST /league_meets.json
  def create
    @league_meet = LeagueMeet.new(league_meet_params)

    respond_to do |format|
      if @league_meet.save
        format.html { redirect_to @league_meet, notice: 'League meet was successfully created.' }
        format.json { render :show, status: :created, location: @league_meet }
      else
        format.html { render :new }
        format.json { render json: @league_meet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /league_meets/1
  # PATCH/PUT /league_meets/1.json
  def update
    respond_to do |format|
      if @league_meet.update(league_meet_params)
        format.html { redirect_to @league_meet, notice: 'League meet was successfully updated.' }
        format.json { render :show, status: :ok, location: @league_meet }
      else
        format.html { render :edit }
        format.json { render json: @league_meet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /league_meets/1
  # DELETE /league_meets/1.json
  def destroy
    # @league_meet.destroy
    # respond_to do |format|
    #   format.html { redirect_to league_meets_url, notice: 'League meet was successfully destroyed.' }
    #   format.json { head :no_content }
    # end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_league_meet
      @league_meet = LeagueMeet.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def league_meet_params
      params.require(:league_meet).permit(:name, :description, :meetid)
    end
end
