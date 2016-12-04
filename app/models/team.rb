class Team < ApplicationRecord
    has_many :team_assets, dependent: :destroy
    # belongs_to :league_meet_event_teams
end
