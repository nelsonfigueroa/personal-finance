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

ActiveRecord::Schema[7.1].define(version: 2024_06_03_081419) do
  create_table "accounts", force: :cascade do |t|
    t.integer "user_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_accounts_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.integer "user_id"
    t.string "name"
    t.string "color"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "transactions_count"
    t.index ["name", "user_id"], name: "index_categories_on_name_and_user_id", unique: true
    t.index ["user_id"], name: "index_categories_on_user_id"
  end

  create_table "statements", force: :cascade do |t|
    t.integer "account_id"
    t.text "notes"
    t.date "date"
    t.integer "balance_cents", default: 0, null: false
    t.string "balance_currency", default: "USD", null: false
    t.index ["account_id"], name: "index_statements_on_account_id"
    t.index ["date", "account_id"], name: "index_statements_on_date_and_account_id", unique: true
  end

  create_table "transactions", force: :cascade do |t|
    t.integer "user_id"
    t.date "date"
    t.string "category"
    t.text "notes"
    t.integer "amount_cents", default: 0, null: false
    t.string "amount_currency", default: "USD", null: false
    t.integer "category_id"
    t.string "merchant"
    t.index ["category"], name: "index_transactions_on_category"
    t.index ["category_id"], name: "index_transactions_on_category_id"
    t.index ["user_id"], name: "index_transactions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "accounts", "users"
  add_foreign_key "categories", "users"
  add_foreign_key "statements", "accounts"
  add_foreign_key "transactions", "categories"
  add_foreign_key "transactions", "users"
end
