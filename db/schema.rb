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

ActiveRecord::Schema.define(version: 20151211134342) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bling_orders", force: :cascade do |t|
    t.integer  "vnda_order_id"
    t.integer  "bling_order_id"
    t.integer  "bling_nfe_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "bling_danfe_key"
    t.string   "bling_danfe_url"
    t.integer  "shop_id"
  end

  add_index "bling_orders", ["bling_nfe_id"], name: "index_bling_orders_on_bling_nfe_id", using: :btree
  add_index "bling_orders", ["bling_order_id"], name: "index_bling_orders_on_bling_order_id", using: :btree
  add_index "bling_orders", ["vnda_order_id"], name: "index_bling_orders_on_vnda_order_id", using: :btree

  create_table "shops", force: :cascade do |t|
    t.string   "name",                                null: false
    t.string   "access_token",                        null: false
    t.string   "bling_key",                           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "bling_api_version",    default: "v1"
    t.integer  "nfe_serie",            default: 1
    t.boolean  "bling_generate_nfe",   default: true
    t.boolean  "bling_generate_danfe", default: true
  end

end
