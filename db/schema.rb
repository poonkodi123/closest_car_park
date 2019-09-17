# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_09_17_111329) do

  create_table "car_park_availabilities", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "total_lots", default: 0
    t.integer "lots_available", default: 0
    t.string "lot_type"
    t.string "carpark_number"
    t.integer "car_park_id"
    t.datetime "update_datetime"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["total_lots", "lots_available"], name: "index_car_park_availabilities_on_total_lots_and_lots_available"
  end

  create_table "car_parks", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "car_park_no"
    t.text "address"
    t.float "x_coord"
    t.float "y_coord"
    t.float "latitude"
    t.float "longitude"
    t.string "car_park_type"
    t.string "type_of_parking_system"
    t.string "short_term_parking"
    t.string "free_parking"
    t.string "night_parking"
    t.integer "car_park_decks", default: 0
    t.float "gantry_height"
    t.string "car_park_basement"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["latitude", "longitude"], name: "index_car_parks_on_latitude_and_longitude"
  end

end
