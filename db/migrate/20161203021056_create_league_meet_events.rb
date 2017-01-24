class CreateLeagueMeetEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :league_meet_events do |t|
      t.belongs_to :league_meet, index: true
    #   t.string :name
      t.integer :red1
      t.integer :red2
      t.integer :red3
      t.integer :blue1
      t.integer :blue2
      t.integer :blue3

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
    #   t.integer :eventid
    #   t.integer :meetid
      t.timestamps
    end
  end
end
