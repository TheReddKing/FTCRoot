class CreateLeagueMeets < ActiveRecord::Migration[5.0]
  def change
    create_table :league_meets do |t|
      t.string :name
    #   t.text :description
    #   t.integer :meetid

      t.timestamps
    end
  end
end
