class LeagueMeet < ApplicationRecord
    belongs_to :region
    has_many :league_meet_events, dependent: :destroy
    has_many :league_meet_event_teams, :through => :league_meet_events
end
