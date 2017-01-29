class CreateEventEventTeams < ActiveRecord::Migration[5.0]
  def change
    create_table :event_event_teams do |t|
      t.belongs_to :event_event, index: true
      t.integer :teamid
      t.string :alliance
    #   t.integer :eventid

      t.timestamps
    end
  end
end
