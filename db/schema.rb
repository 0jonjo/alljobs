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

ActiveRecord::Schema.define(version: 2022_07_03_103539) do

  create_table "applies", force: :cascade do |t|
    t.integer "job_id", null: false
    t.integer "user_id", null: false
    t.boolean "application_user"
    t.boolean "accepted_headhunter"
    t.text "feedback_headhunter"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["job_id"], name: "index_applies_on_job_id"
    t.index ["user_id"], name: "index_applies_on_user_id"
  end

  create_table "comments", force: :cascade do |t|
    t.datetime "datetime"
    t.text "body"
    t.integer "profile_id", null: false
    t.integer "headhunter_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["headhunter_id"], name: "index_comments_on_headhunter_id"
    t.index ["profile_id"], name: "index_comments_on_profile_id"
  end

  create_table "headhunters", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_headhunters_on_email", unique: true
    t.index ["reset_password_token"], name: "index_headhunters_on_reset_password_token", unique: true
  end

  create_table "jobs", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.text "skills"
    t.decimal "salary"
    t.string "company"
    t.string "level"
    t.string "place"
    t.date "date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "code"
    t.integer "job_status", default: 1
  end

  create_table "profiles", force: :cascade do |t|
    t.string "name"
    t.string "social_name"
    t.date "birthdate"
    t.text "description"
    t.text "educacional_background"
    t.text "experience"
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "stars", force: :cascade do |t|
    t.integer "headhunter_id", null: false
    t.integer "profile_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "apply_id", null: false
    t.index ["apply_id"], name: "index_stars_on_apply_id"
    t.index ["headhunter_id"], name: "index_stars_on_headhunter_id"
    t.index ["profile_id"], name: "index_stars_on_profile_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "applies", "jobs"
  add_foreign_key "applies", "users"
  add_foreign_key "comments", "headhunters"
  add_foreign_key "comments", "profiles"
  add_foreign_key "profiles", "users"
  add_foreign_key "stars", "applies"
  add_foreign_key "stars", "headhunters"
  add_foreign_key "stars", "profiles"
end
