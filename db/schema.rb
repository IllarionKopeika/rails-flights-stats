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

ActiveRecord::Schema[8.0].define(version: 2025_05_16_071851) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "aircrafts", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.string "manufacturer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "airlines", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.string "logo_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "airports", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.bigint "country_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "timezone"
    t.float "latitude"
    t.float "longitude"
    t.index ["country_id"], name: "index_airports_on_country_id"
  end

  create_table "countries", force: :cascade do |t|
    t.jsonb "name", default: {}, null: false
    t.string "code"
    t.string "flag_url"
    t.bigint "subregion_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_countries_on_name", using: :gin
    t.index ["subregion_id"], name: "index_countries_on_subregion_id"
  end

  create_table "flights", force: :cascade do |t|
    t.string "number"
    t.string "departure_date"
    t.string "departure_time"
    t.string "arrival_date"
    t.string "arrival_time"
    t.integer "duration"
    t.float "distance"
    t.integer "status"
    t.bigint "airline_id", null: false
    t.bigint "aircraft_id", null: false
    t.bigint "departure_airport_id", null: false
    t.bigint "arrival_airport_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["aircraft_id"], name: "index_flights_on_aircraft_id"
    t.index ["airline_id"], name: "index_flights_on_airline_id"
    t.index ["arrival_airport_id"], name: "index_flights_on_arrival_airport_id"
    t.index ["departure_airport_id"], name: "index_flights_on_departure_airport_id"
    t.index ["number", "departure_date"], name: "index_flights_on_number_and_departure_date", unique: true
    t.index ["user_id"], name: "index_flights_on_user_id"
  end

  create_table "regions", force: :cascade do |t|
    t.jsonb "name", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_regions_on_name", using: :gin
  end

  create_table "sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "subregions", force: :cascade do |t|
    t.jsonb "name", default: {}, null: false
    t.bigint "region_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_subregions_on_name", using: :gin
    t.index ["region_id"], name: "index_subregions_on_region_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "airports", "countries"
  add_foreign_key "countries", "subregions"
  add_foreign_key "flights", "aircrafts"
  add_foreign_key "flights", "airlines"
  add_foreign_key "flights", "airports", column: "arrival_airport_id"
  add_foreign_key "flights", "airports", column: "departure_airport_id"
  add_foreign_key "flights", "users"
  add_foreign_key "sessions", "users"
  add_foreign_key "subregions", "regions"
end
