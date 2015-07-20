# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150719234349) do

  create_table "clients", force: :cascade do |t|
    t.string "name"
    t.string "contact"
  end

  create_table "orders", force: :cascade do |t|
    t.integer "client_id"
    t.string  "service"
    t.integer "service_fee_cents",      default: 0,     null: false
    t.string  "service_fee_currency",   default: "USD", null: false
    t.date    "order_date"
    t.date    "complete_date"
    t.date    "paid_date"
    t.date    "external_reference_num"
    t.string  "prop_name"
  end

end
