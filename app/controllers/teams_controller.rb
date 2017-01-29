class TeamsController < ApplicationController
    before_action :set_team, only: [:show, :edit, :plain, :update, :destroy]

    # GET /teams
    # GET /teams.json
    def index
        @teams = if params[:search] != nil and params[:search].length > 0
                    if(ActiveRecord::Base.connection.adapter_name == 'Mysql2' )
                        Team.where('CAST(id as CHAR) like ? or lower(name) like lower(?)', "#{params[:search].to_i}%", "%#{params[:search]}%")
                    else
                        Team.where('id::text like ? or lower(name) like lower(?)', "#{params[:search].to_i}%", "%#{params[:search]}%")
                    end
                else
                    # Team.where("blurb is not null").or Team.where("blurb is null")
                    Team.all.order("blurb is null, id asc")
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
        events = @team.data_competitions.split("|")
        @competitions = []
        for meet in events
            @competitions.push(Event.find(meet.gsub("_","")))
        end
        @avgAuto = 0
        @important = -1
        if(@competitions.length != 0)
            @competitions = @competitions.sort_by { |k,_| Date.strptime(k.date,"%m/%d/%Y") }.reverse
            compet = []
            @competitions.each do |com|
                alldata = com.data_competition.split("|")
                meetdat = []
                meet = Hash.new
                meet[:wins] = 0
                meet[:draws] = 0
                for c in alldata
                    comp = c.split(",")
                    if((","+ comp[1,6].join(",")+",").include?(",#{@team.id},"))
                        # puts c
                        dat = Hash.new
                        dat[:name] = comp[0]
                        if comp[3].to_i == 0
                            dat[:redteam] = comp[1,2]
                            dat[:blueteam] = comp[4,2]
                            dat[:numteams] = 3
                        else
                            dat[:redteam] = comp[1,3]
                            dat[:blueteam] = comp[4,3]
                            dat[:numteams] = 2
                        end
                        if(com.advanceddata)
                            #dat = "#{event.redscore},#{event.redauto},#{event.redteleop},#{event.redend},#{event.redpenalty}"
                            dat[:reddetails] = comp[7,6].join(",")
                            dat[:bluedetails] = comp[13,6].join(",")
                            dat[:redscore] = comp[7]
                            dat[:bluescore] = comp[13]
                        else
                            dat[:reddetails] = ""
                            dat[:bluedetails] = ""
                            dat[:redscore] = comp[7]
                            dat[:bluescore] = comp[8]
                        end

                        if((","+ comp[1,3].join(",")+",").include?(",#{@team.id},"))
                            # Red
                            dat[:ownscore] = dat[:redscore]
                            dat[:oppscore] = dat[:bluescore]
                            dat[:owndetails] = dat[:reddetails]
                            dat[:oppdetails] = dat[:bluedetails]
                        else
                            dat[:ownscore] = dat[:bluescore]
                            dat[:oppscore] = dat[:redscore]
                            dat[:owndetails] = dat[:bluedetails]
                            dat[:oppdetails] = dat[:reddetails]
                        end
                        if dat[:ownscore].to_i > dat[:oppscore].to_i
                            meet[:wins] += 1
                        elsif dat[:ownscore].to_i == dat[:oppscore].to_i
                            meet[:draws] += 1
                        end
                        meetdat.push(dat)
                    end
                end
                allstats = com.data_stats.split("|")
                for s in allstats
                    spl = s.split(",")
                    if(spl[0] == @team.id.to_s)
                        meet[:rank] = spl[1]
                        meet[:rank_all] = allstats.length
                        break
                    end
                end
                meet[:data] = meetdat
                meet[:meet] = com
                compet.push(meet)
            end
            @competitions = compet
            # raise
            @avgPreScore = 0


            @avgTele = 0
            @avgEnd = 0
            @avgAuto = 0
            @totalMatches = 0
            @avgData = []
            # More data analysis
            @competitions.each_with_index do |meet,i|
                # ONLY DETAILED DATA HAS IT
                #dat = "#{event.redscore},#{event.redauto},#{event.redteleop},#{event.redend},#{event.redpenalty}"
                @avgPreScore = 0
                @avgTele = 0
                @avgEnd = 0
                @avgAuto = 0
                @totalMatches = 0
                meet[:data].each do |event|
                    if(event[:owndetails].length > 0)
                        det = event[:owndetails].split(",")
                        @avgPreScore += event[:ownscore].to_i - det[5].to_i
                        @avgTele += det[3].to_i
                        @avgEnd += det[4].to_i
                        @avgAuto += det[1].to_i
                        @totalMatches += 1
                        if(@important == -1)
                            @important = i
                        end
                    end
                end
                if(@totalMatches > 0 )
                    @avgTele /= @totalMatches
                    @avgEnd /= @totalMatches
                    @avgAuto /= @totalMatches
                    @avgPreScore /= @totalMatches
                end
                @avgData.push([@totalMatches,@avgPreScore,@avgAuto,@avgTele,@avgEnd])
            end
        end
    end

    # GET /teams/new
    def new
        @team = Team.new
    end

    # GET /teams/1/plain
    # GET /teams/1.json/plain
    def plain
        if params[:showlink]
            @existssss = "HI"
        end
        render :partial => "plain"
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
