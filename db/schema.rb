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

ActiveRecord::Schema[8.0].define(version: 2024_12_24_025812) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "accounts", primary_key: "number", id: :serial, force: :cascade do |t|
    t.string "name"
    t.boolean "vip"
    t.string "password_digest"
    t.decimal "value_account"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "movimentations", force: :cascade do |t|
    t.decimal "value"
    t.decimal "tax", default: "0.0"
    t.string "description"
    t.integer "account_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_number"], name: "index_movimentations_on_account_number"
  end

  add_foreign_key "movimentations", "accounts", column: "account_number", primary_key: "number"
end
