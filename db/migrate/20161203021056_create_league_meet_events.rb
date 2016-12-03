class CreateLeagueMeetEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :league_meet_events do |t|
      t.string :name
      t.integer :redscore
      t.integer :redauto
      t.integer :redteleop
      t.integer :redend
      t.integer :redpenalty

      t.integer :bluescore
      t.integer :blueauto
      t.integer :blueteleop
      t.integer :blueend
      t.integer :bluepenalty

      t.integer :order
      t.integer :eventid
      t.integer :meetid

      t.timestamps
    end
  end
end
