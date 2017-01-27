class AddStatsToLeagueMeets < ActiveRecord::Migration[5.0]
  def change
    add_column :league_meets, :data_stats, :text
    add_column :league_meets, :data_highscore, :string
  end
end
