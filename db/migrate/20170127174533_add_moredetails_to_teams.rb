class AddMoredetailsToTeams < ActiveRecord::Migration[5.0]
  def change
    add_column :teams, :contact_email, :string
    add_column :teams, :contact_twitter, :string
    add_column :teams, :data_opr, :string
    add_column :teams, :data_oprauto, :string
    add_column :teams, :data_oprtele, :string
    add_column :teams, :data_oprend, :string
  end
end
