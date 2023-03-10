class CreateLocations < ActiveRecord::Migration[7.0]
  def change
    create_table :locations, id: :uuid do |t|
      t.string :external_id, unique: true
      t.string :city, index: true
      t.string :state, index: true
      t.string :country
      t.string :zipcode, index: true
      t.float :lat
      t.float :lon
      t.integer :utc_offset, default: 0
      t.timestamps
      t.datetime :last_sync_at, index: true
      t.datetime :last_forecast_sync_at, index: true
      t.string :weather_point_id
    end

    add_index :locations, :created_at, order: :desc
  end
end
