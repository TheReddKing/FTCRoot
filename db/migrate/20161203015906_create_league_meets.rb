class CreateLeagueMeets < ActiveRecord::Migration[5.0]
  def change
    create_table :league_meets do |t|
      t.belongs_to :region, index: true
      t.string :name
      t.string :date
      t.text :description
      t.string :location
    #   t.integer :meetid

      t.timestamps
    end
  end
end
