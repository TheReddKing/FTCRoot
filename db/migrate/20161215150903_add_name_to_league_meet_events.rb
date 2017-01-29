class AddNameToEventEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :event_events, :name, :string
  end
end
