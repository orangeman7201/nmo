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

ActiveRecord::Schema[7.1].define(version: 2024_04_29_105537) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "conditions", force: :cascade do |t|
    t.string "detail", null: false, comment: "症状の詳細"
    t.date "occurred_date", null: false, comment: "症状があった日"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.integer "strength", comment: "症状の強さ"
    t.text "memo", comment: "メモ"
    t.index ["user_id"], name: "index_conditions_on_user_id"
  end

  create_table "consultation_reports", force: :cascade do |t|
    t.text "condition_summary", comment: "気になることのまとめ"
    t.text "consultation_memo", comment: "診断メモ"
    t.date "start_date", comment: "レポートの開始日時"
    t.date "end_date", null: false, comment: "レポートの終了日時"
    t.bigint "user_id", null: false, comment: "ユーザーID"
    t.bigint "hospital_appointment_id", null: false, comment: "病院予約ID"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hospital_appointment_id"], name: "index_consultation_reports_on_hospital_appointment_id"
    t.index ["user_id"], name: "index_consultation_reports_on_user_id"
  end

  create_table "hospital_appointments", force: :cascade do |t|
    t.date "consultation_date", null: false, comment: "診察日"
    t.text "memo", comment: "メモ"
    t.bigint "user_id", null: false, comment: "ユーザーID"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_hospital_appointments_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "name"
    t.string "nickname"
    t.string "image"
    t.string "email"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.json "tokens"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  add_foreign_key "conditions", "users"
  add_foreign_key "consultation_reports", "hospital_appointments"
  add_foreign_key "consultation_reports", "users"
  add_foreign_key "hospital_appointments", "users"
end
