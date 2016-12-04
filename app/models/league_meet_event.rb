class LeagueMeetEvent < ApplicationRecord
    belongs_to :league_meet
    has_many :league_meet_event_teams
end
