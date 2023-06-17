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

ActiveRecord::Schema.define(version: 2023_06_17_125623) do

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "applies", force: :cascade do |t|
    t.integer "job_id", null: false
    t.integer "user_id", null: false
    t.text "feedback_headhunter"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["job_id"], name: "index_applies_on_job_id"
    t.index ["user_id"], name: "index_applies_on_user_id"
  end

  create_table "comments", force: :cascade do |t|
    t.text "body"
    t.integer "profile_id", null: false
    t.integer "headhunter_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["headhunter_id"], name: "index_comments_on_headhunter_id"
    t.index ["profile_id"], name: "index_comments_on_profile_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.string "website"
    t.string "email"
    t.string "phone"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "countries", force: :cascade do |t|
    t.string "acronym"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "feedback_applies", force: :cascade do |t|
    t.text "body"
    t.integer "headhunter_id", null: false
    t.integer "apply_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["apply_id"], name: "index_feedback_applies_on_apply_id"
    t.index ["headhunter_id"], name: "index_feedback_applies_on_headhunter_id"
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
    t.integer "salary"
    t.string "level"
    t.date "date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "code"
    t.integer "job_status", default: 1
    t.integer "country_id"
    t.integer "company_id"
    t.string "city"
    t.index ["company_id"], name: "index_jobs_on_company_id"
    t.index ["country_id"], name: "index_jobs_on_country_id"
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
    t.integer "country_id"
    t.string "city"
    t.index ["country_id"], name: "index_profiles_on_country_id"
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "proposal_comments", force: :cascade do |t|
    t.text "body"
    t.integer "author"
    t.integer "proposal_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["proposal_id"], name: "index_proposal_comments_on_proposal_id"
  end

  create_table "proposals", force: :cascade do |t|
    t.integer "apply_id", null: false
    t.decimal "salary"
    t.string "benefits"
    t.string "expectations"
    t.date "expected_start"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "user_accepted"
    t.index ["apply_id"], name: "index_proposals_on_apply_id"
  end

  create_table "stars", force: :cascade do |t|
    t.integer "headhunter_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "apply_id", null: false
    t.index ["apply_id"], name: "index_stars_on_apply_id"
    t.index ["headhunter_id"], name: "index_stars_on_headhunter_id"
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
  add_foreign_key "feedback_applies", "applies"
  add_foreign_key "feedback_applies", "headhunters"
  add_foreign_key "jobs", "companies"
  add_foreign_key "jobs", "countries"
  add_foreign_key "profiles", "countries"
  add_foreign_key "profiles", "users"
  add_foreign_key "proposal_comments", "proposals"
  add_foreign_key "proposals", "applies"
  add_foreign_key "stars", "applies"
  add_foreign_key "stars", "headhunters"
end
