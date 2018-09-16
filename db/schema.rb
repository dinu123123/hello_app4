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

ActiveRecord::Schema.define(version: 20180912195708) do

  create_table "Events", force: :cascade do |t|
    t.datetime "DATE"
    t.integer "DRIVER_id"
    t.integer "truck_id"
    t.boolean "START_END"
    t.integer "client_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "be_tolls", force: :cascade do |t|
    t.integer "record_number"
    t.string "reference_number"
    t.date "date_of_detailed_trip_statement"
    t.string "identification_of_the_road_network_user"
    t.date "bill_cycle_start_date"
    t.date "bill_cycle_end_date"
    t.string "obu_serial_number"
    t.string "internal_obu_identifier"
    t.string "country_code"
    t.string "licence_plate_number"
    t.string "euro_emission_class"
    t.string "gross_combination_weight"
    t.string "payment_method"
    t.date "date_of_processing"
    t.date "date_of_usage"
    t.string "toll_charger"
    t.string "road_type"
    t.string "route"
    t.time "entry_time"
    t.decimal "charged_distance"
    t.string "distance_unit"
    t.decimal "charged_amount_excluding_vat"
    t.string "currency"
    t.string "vat_indicator"
    t.integer "truck_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "belgium_tolls", force: :cascade do |t|
    t.date "StartDate"
    t.time "StartTime"
    t.date "EndDate"
    t.time "EndTime"
    t.decimal "Km"
    t.decimal "EUR"
    t.integer "truck_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "clients", force: :cascade do |t|
    t.string "Name"
    t.string "Address"
    t.string "BankAccount"
    t.integer "PaymentDelay"
    t.integer "event_id"
    t.integer "client_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "de_tolls", force: :cascade do |t|
    t.string "platenr"
    t.date "date"
    t.time "time"
    t.string "bookingid"
    t.integer "art"
    t.string "road"
    t.string "via"
    t.string "departure"
    t.integer "costcentre"
    t.integer "tariffmodel"
    t.integer "axelclass"
    t.integer "weightclass"
    t.integer "emissioncat"
    t.integer "roadoperators"
    t.string "ver"
    t.decimal "km"
    t.decimal "eur"
    t.integer "truck_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "driver_expenses", force: :cascade do |t|
    t.integer "DRIVER_id"
    t.integer "truck_id"
    t.date "DATE"
    t.decimal "AMOUNT"
    t.text "INFO"
    t.text "DESCRIPTION"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "drivers", force: :cascade do |t|
    t.text "CNP"
    t.text "FIRSTNAME"
    t.text "SECONDNAME"
    t.date "StartDate"
    t.date "EndDate"
    t.integer "INFO"
    t.text "DESCRIPTION"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fuel_expenses", force: :cascade do |t|
    t.time "trstime"
    t.date "trsdate"
    t.string "product"
    t.decimal "volume"
    t.decimal "eurnetamount"
    t.integer "kminsertion"
    t.string "platenr"
    t.string "cardnr"
    t.integer "stationid"
    t.string "stationname"
    t.decimal "eurgrossunitprice"
    t.decimal "eurgrossamount"
    t.string "country"
    t.integer "truck_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "generic_tolls", force: :cascade do |t|
    t.date "StartDate"
    t.date "EndDate"
    t.decimal "Km"
    t.decimal "EUR"
    t.integer "truck_id"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "germany_tolls", force: :cascade do |t|
    t.string "platenr"
    t.date "date"
    t.time "time"
    t.string "bookingid"
    t.integer "art"
    t.string "road"
    t.string "via"
    t.string "departure"
    t.integer "costcentre"
    t.integer "tariffmodel"
    t.integer "axelclass"
    t.integer "weightclass"
    t.integer "emissioncat"
    t.integer "roadoperators"
    t.string "ver"
    t.decimal "km"
    t.decimal "eur"
    t.integer "truck_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "invoiced_trips", force: :cascade do |t|
    t.date "date"
    t.datetime "StartDate"
    t.datetime "EndDate"
    t.string "invoice_id"
    t.integer "client_id"
    t.integer "DRIVER_id"
    t.integer "truck_id"
    t.decimal "germany_toll"
    t.decimal "belgium_toll"
    t.decimal "swiss_toll"
    t.decimal "france_toll"
    t.decimal "italy_toll"
    t.decimal "uk_toll"
    t.decimal "netherlands_toll"
    t.integer "km"
    t.integer "km_evogps"
    t.integer "km_driver_route_note"
    t.decimal "total_amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "truck_expenses", force: :cascade do |t|
    t.integer "truck_id"
    t.date "DATE"
    t.decimal "AMOUNT"
    t.text "INFO"
    t.text "DESCRIPTION"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "trucks", force: :cascade do |t|
    t.text "NB_PLATE"
    t.text "INFO"
    t.text "CHASSIS"
    t.date "FABDATE"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.boolean "admin", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
