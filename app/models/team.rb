class Team < ApplicationRecord
    has_many :team_assets, dependent: :destroy
    # belongs_to :event_event_teams
end
