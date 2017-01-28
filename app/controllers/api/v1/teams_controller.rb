class Api::V1::TeamsController < ApiController
    before_action :set_team, only: [:show]

	def show
		# team = Team.find(params[:id])
        if @team == nil
            render :json => {"error":222, "status":"Team not found"}
        return
        end
        inc = [:id,:location,:name]
        if(@team.website.length > 0)
            inc.push(:website)
        end
        if(@team.contact_email && @team.contact_email.length > 0)
            inc.push(:contact_email)
        end

        if(@team.contact_twitter && @team.contact_twitter.length > 0)
            inc.push(:contact_twitter)
        end
        json = @team.to_json(:only => inc)

        render :json => json
        # json.array! @teams, partial: 'teams/team', as: :team

		# render :json => team.to_json(:methods => [:profile_url])
	end


    def set_team
        if(Team.exists?(params[:id]))
            @team = Team.find(params[:id])
        end
    end
end
