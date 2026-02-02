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

ActiveRecord::Schema[8.1].define(version: 2026_01_31_223221) do
  create_table "compilations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "input_text"
    t.string "input_type"
    t.string "language"
    t.text "output_text"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_compilations_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "email_confirmation_token"
    t.datetime "email_confirmed_at"
    t.string "name"
    t.string "password_digest"
    t.string "pending_email"
    t.string "reset_token"
    t.datetime "reset_token_expires_at"
    t.datetime "updated_at", null: false
    t.index ["email_confirmation_token"], name: "index_users_on_email_confirmation_token", unique: true
    t.index ["reset_token"], name: "index_users_on_reset_token", unique: true
  end

  add_foreign_key "compilations", "users"
end
