class AddMoreContactInfoToTeams < ActiveRecord::Migration[5.0]
  def change
    add_column :teams, :contact_youtube, :string
    add_column :teams, :contact_facebook, :string
  end
end
