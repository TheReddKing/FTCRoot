class AddWebsiteToTeams < ActiveRecord::Migration[5.0]
  def change
    add_column :teams, :website, :string
  end
end
