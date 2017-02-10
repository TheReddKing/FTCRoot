class AddRawToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :data_raw, :text
    add_column :events, :advancedraw, :boolean
  end
end
