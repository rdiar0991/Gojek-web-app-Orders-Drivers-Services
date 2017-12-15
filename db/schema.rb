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

ActiveRecord::Schema.define(version: 20171215030323) do

  create_table "drivers", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone"
    t.string "password_digest"
    t.decimal "gopay_balance", precision: 8, scale: 2, default: "0.0", null: false
    t.integer "bid_status", default: 0
    t.text "current_location", default: "N/A"
    t.integer "go_service"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "current_coord", default: "N/A"
    t.index ["email"], name: "index_drivers_on_email"
  end

  create_table "orders", force: :cascade do |t|
    t.string "origin"
    t.string "destination"
    t.float "distance"
    t.integer "payment_type"
    t.integer "status"
    t.integer "user_id"
    t.integer "driver_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "price", precision: 8, scale: 2
    t.string "service_type"
    t.index ["driver_id"], name: "index_orders_on_driver_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.decimal "gopay_balance", precision: 8, scale: 2, default: "0.0", null: false
    t.string "phone"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
