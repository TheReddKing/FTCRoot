class EventEvent < ApplicationRecord
    belongs_to :event
    has_many :event_event_teams
end
