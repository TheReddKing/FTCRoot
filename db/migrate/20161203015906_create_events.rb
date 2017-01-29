class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.belongs_to :region, index: true
      t.string :name
      t.string :date
      t.string :ftcmatchcode
      t.text :description
      t.string :location
      t.string :competitiontype
      t.text :data_competition
      t.boolean :advanceddata
      t.timestamps
    end
  end
end
