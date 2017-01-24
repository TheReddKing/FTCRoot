class CreateTeams < ActiveRecord::Migration[5.0]
  def change
    create_table :teams do |t|
      t.string :name
    #   t.integer :teamid
      t.string :location
      t.float :location_lat
      t.float :location_long
      t.timestamps
    end
  end
end

# rake db:drop db:create db:migrate
