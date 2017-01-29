class Event < ApplicationRecord
    belongs_to :region
    has_many :event_events, dependent: :destroy
    has_many :event_event_teams, :through => :event_events
end
