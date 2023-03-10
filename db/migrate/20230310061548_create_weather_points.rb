class CreateWeatherPoints < ActiveRecord::Migration[7.0]
  def change
    create_table :weather_points, id: :uuid do |t|
      t.uuid :location_id, index: true, null: false
      t.string :external_id
      t.integer :utc_offset
      t.float :lat
      t.float :lon
      t.integer :temp
      t.integer :temp_min
      t.integer :temp_max
      t.integer :temp_feels_like
      t.integer :pressure
      t.integer :humidity
      t.integer :visibility
      t.integer :wind_speed
      t.string :condition
      t.string :condition_code
      t.integer :sunrise_ts
      t.integer :sunset_ts
      t.integer :ts
      t.datetime :created_at
    end
  end
end
