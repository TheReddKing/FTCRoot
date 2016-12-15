class CreateEventMigrations < ActiveRecord::Migration[5.0]
  def change
    create_table :event_migrations do |t|
      t.string :name
      t.string :migration_date

      t.timestamps
    end
  end
end
