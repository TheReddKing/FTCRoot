class AddNameToLeagueMeetEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :league_meet_events, :name, :string
  end
end
