class AddStatsToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :data_stats, :text
    add_column :events, :data_highscore, :string
    add_column :events, :advancedstats, :boolean
  end
end
