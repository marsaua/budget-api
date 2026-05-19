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

ActiveRecord::Schema[8.1].define(version: 2026_05_19_090000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "jwt_denylist", force: :cascade do |t|
    t.datetime "exp", null: false
    t.string "jti", null: false
    t.index ["jti"], name: "index_jwt_denylist_on_jti"
  end

  create_table "memberships", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "role", default: "member", null: false
    t.bigint "room_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["room_id"], name: "index_memberships_on_room_id"
    t.index ["user_id", "room_id"], name: "index_memberships_on_user_id_and_room_id", unique: true
    t.index ["user_id"], name: "index_memberships_on_user_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "owner_id", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id"], name: "index_rooms_on_owner_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.decimal "amount", precision: 12, scale: 2, null: false
    t.bigint "author_id"
    t.string "category", default: "other", null: false
    t.datetime "created_at", null: false
    t.string "description", null: false
    t.string "kind", default: "expense", null: false
    t.date "occurred_on", null: false
    t.bigint "room_id"
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_transactions_on_author_id"
    t.index ["category"], name: "index_transactions_on_category"
    t.index ["kind"], name: "index_transactions_on_kind"
    t.index ["occurred_on"], name: "index_transactions_on_occurred_on"
    t.index ["room_id"], name: "index_transactions_on_room_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "memberships", "rooms"
  add_foreign_key "memberships", "users"
  add_foreign_key "rooms", "users", column: "owner_id"
  add_foreign_key "transactions", "rooms"
  add_foreign_key "transactions", "users", column: "author_id"
end
