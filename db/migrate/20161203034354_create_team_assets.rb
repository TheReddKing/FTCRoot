class CreateTeamAssets < ActiveRecord::Migration[5.0]
  def change
    create_table :team_assets do |t|
      t.belongs_to :team, index: true
      t.string :content
      t.string :ctype

      t.timestamps
    end
  end
end
