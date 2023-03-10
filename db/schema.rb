# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_03_10_061548) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "locations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "external_id"
    t.string "city"
    t.string "state"
    t.string "country"
    t.string "zipcode"
    t.float "lat"
    t.float "lon"
    t.integer "utc_offset", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "last_sync_at"
    t.datetime "last_forecast_sync_at"
    t.string "weather_point_id"
    t.index ["city"], name: "index_locations_on_city"
    t.index ["created_at"], name: "index_locations_on_created_at", order: :desc
    t.index ["last_forecast_sync_at"], name: "index_locations_on_last_forecast_sync_at"
    t.index ["last_sync_at"], name: "index_locations_on_last_sync_at"
    t.index ["state"], name: "index_locations_on_state"
    t.index ["zipcode"], name: "index_locations_on_zipcode"
  end

  create_table "weather_points", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "location_id", null: false
    t.string "external_id"
    t.integer "utc_offset"
    t.float "lat"
    t.float "lon"
    t.integer "temp"
    t.integer "temp_min"
    t.integer "temp_max"
    t.integer "temp_feels_like"
    t.integer "pressure"
    t.integer "humidity"
    t.integer "visibility"
    t.integer "wind_speed"
    t.string "condition"
    t.string "condition_code"
    t.integer "sunrise_ts"
    t.integer "sunset_ts"
    t.integer "ts"
    t.datetime "created_at"
    t.index ["location_id"], name: "index_weather_points_on_location_id"
  end

end
