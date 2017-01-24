class AddWebsiteToTeams < ActiveRecord::Migration[5.0]
  def change
    add_column :teams, :website, :string
    add_column :teams, :contact, :string
    add_column :teams, :data_competitions, :text
    add_column :teams, :blurb, :text
    add_column :teams, :data_strong, :string
    add_column :teams, :data_rootrank, :string
    add_column :teams, :data_rootscore, :string
    # List of competitions
  end
end
