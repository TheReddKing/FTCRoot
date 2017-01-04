class TeamsController < ApplicationController
    before_action :set_team, only: [:show, :edit, :plain, :update, :destroy]

    # GET /teams
    # GET /teams.json
    def index
        @teams = if params[:search] != nil
                    Team.where('lower(CAST(id as CHAR)) like lower(?) or lower(name) like lower(?)', "#{params[:search].to_i}%", "%#{params[:search]}%")
                else
                    Team.all
                end
        @teams = @teams.paginate(:page => params[:page], :per_page => 30)
    end

    # GET /teams/1
    # GET /teams/1.json
    def show
        if(!params[:name])
            respond_to do |format|
                format.html { redirect_to fullname_path(:name=>@team.name.gsub(/[^A-Za-z0-9_ ]/,"").gsub(" ","_")) }
            end
            return
            # render :search
            # return
        end
        @competitions = LeagueMeetEvent.all.where("red1 = ? OR red2 = ? OR blue1 = ? OR blue2 = ?", @team.id, @team.id,@team.id,@team.id)
    end

    # GET /teams/new
    def new
        @team = Team.new
    end

    # GET /teams/1/plain
    # GET /teams/1.json/plain
    def plain
        render layout: false
        # render :layout => false
    end

    # GET /teams/1/edit
    def edit; end

    # POST /teams
    # POST /teams.json
    def create
        respond_to do |format|
            format.html { redirect_to :teams, notice: 'Team creation not allowed... But you seem to have a little bit of knowledge...' }
        end
        nil
        # goes to private load_team
    end

    # PATCH/PUT /teams/1
    # PATCH/PUT /teams/1.json
    def update
        respond_to do |format|
            if @team.update(team_params)
                format.html { redirect_to @team, notice: 'Team was successfully updated.' }
                format.json { render :show, status: :ok, location: @team }
            else
                format.html { render :edit }
                format.json { render json: @team.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /teams/1
    # DELETE /teams/1.json
    def destroy
        # @team.destroy
        # respond_to do |format|
        #     format.html { redirect_to teams_url, notice: 'Team was successfully destroyed.' }
        #     format.json { head :no_content }
        # end
    end

    private

    # def load_team(params)
    #     @team = Team.new(params)
    #
    #     respond_to do |format|
    #       if @team.save®
    #         format.html { redirect_to @team, notice: 'Team was successfully created.' }
    #         format.json { render :show, status: :created, location: @team }
    #       else
    #         format.html { render :new }
    #         format.json { render json: @team.errors, status: :unprocessable_entity }
    #       end
    #     end
    # end

    # Use callbacks to share common setup or constraints between actions.
    def set_team
        @team = Team.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def team_params
        params.require(:team).permit(:name, :search,:page, :location, :location_lat, :location_long)
    end
end
