# frozen_string_literal: true

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

ActiveRecord::Schema[7.1].define(version: 20_231_022_190_716) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'admins', force: :cascade do |t|
    t.text 'email', default: '', null: false
    t.text 'encrypted_password', default: '', null: false
    t.text 'reset_password_token'
    t.datetime 'reset_password_sent_at', precision: nil
    t.datetime 'remember_created_at', precision: nil
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['email'], name: 'index_admins_on_email', unique: true
    t.index ['reset_password_token'], name: 'index_admins_on_reset_password_token', unique: true
  end

  create_table 'applies', force: :cascade do |t|
    t.bigint 'job_id', null: false
    t.bigint 'user_id', null: false
    t.text 'feedback_headhunter'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['job_id'], name: 'index_applies_on_job_id'
    t.index ['user_id'], name: 'index_applies_on_user_id'
  end

  create_table 'comments', force: :cascade do |t|
    t.text 'body'
    t.bigint 'profile_id', null: false
    t.bigint 'headhunter_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['headhunter_id'], name: 'index_comments_on_headhunter_id'
    t.index ['profile_id'], name: 'index_comments_on_profile_id'
  end

  create_table 'companies', force: :cascade do |t|
    t.text 'name', null: false
    t.text 'description'
    t.text 'website'
    t.text 'email'
    t.text 'phone'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'countries', force: :cascade do |t|
    t.text 'acronym'
    t.text 'name'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'delayed_jobs', force: :cascade do |t|
    t.integer 'priority', default: 0, null: false
    t.integer 'attempts', default: 0, null: false
    t.text 'handler', null: false
    t.text 'last_error'
    t.datetime 'run_at', precision: nil
    t.datetime 'locked_at', precision: nil
    t.datetime 'failed_at', precision: nil
    t.string 'locked_by'
    t.string 'queue'
    t.datetime 'created_at'
    t.datetime 'updated_at'
    t.index %w[priority run_at], name: 'delayed_jobs_priority'
  end

  create_table 'feedback_applies', force: :cascade do |t|
    t.text 'body'
    t.bigint 'headhunter_id', null: false
    t.bigint 'apply_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['apply_id'], name: 'index_feedback_applies_on_apply_id'
    t.index ['headhunter_id'], name: 'index_feedback_applies_on_headhunter_id'
  end

  create_table 'headhunters', force: :cascade do |t|
    t.text 'email', default: '', null: false
    t.text 'encrypted_password', default: '', null: false
    t.text 'reset_password_token'
    t.datetime 'reset_password_sent_at', precision: nil
    t.datetime 'remember_created_at', precision: nil
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['email'], name: 'index_headhunters_on_email', unique: true
    t.index ['reset_password_token'], name: 'index_headhunters_on_reset_password_token', unique: true
  end

  create_table 'jobs', force: :cascade do |t|
    t.text 'title'
    t.text 'description'
    t.text 'skills'
    t.decimal 'salary'
    t.text 'level'
    t.date 'date'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'code'
    t.integer 'job_status', default: 1
    t.bigint 'country_id'
    t.bigint 'company_id'
    t.string 'city'
    t.index ['company_id'], name: 'index_jobs_on_company_id'
    t.index ['country_id'], name: 'index_jobs_on_country_id'
  end

  create_table 'profiles', force: :cascade do |t|
    t.text 'name'
    t.text 'social_name'
    t.date 'birthdate'
    t.text 'description'
    t.text 'educacional_background'
    t.text 'experience'
    t.bigint 'user_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.bigint 'country_id'
    t.string 'city'
    t.index ['country_id'], name: 'index_profiles_on_country_id'
    t.index ['user_id'], name: 'index_profiles_on_user_id'
  end

  create_table 'proposal_comments', force: :cascade do |t|
    t.text 'body'
    t.bigint 'proposal_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'author_type'
    t.bigint 'author_id'
    t.index %w[author_type author_id], name: 'index_proposal_comments_on_author'
    t.index ['proposal_id'], name: 'index_proposal_comments_on_proposal_id'
  end

  create_table 'proposals', force: :cascade do |t|
    t.bigint 'apply_id', null: false
    t.decimal 'salary'
    t.text 'benefits'
    t.text 'expectations'
    t.date 'expected_start'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.boolean 'user_accepted'
    t.index ['apply_id'], name: 'index_proposals_on_apply_id'
  end

  create_table 'stars', force: :cascade do |t|
    t.bigint 'headhunter_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.bigint 'apply_id', null: false
    t.index ['apply_id'], name: 'index_stars_on_apply_id'
    t.index ['headhunter_id'], name: 'index_stars_on_headhunter_id'
  end

  create_table 'users', force: :cascade do |t|
    t.text 'email', default: '', null: false
    t.text 'encrypted_password', default: '', null: false
    t.text 'reset_password_token'
    t.datetime 'reset_password_sent_at', precision: nil
    t.datetime 'remember_created_at', precision: nil
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['email'], name: 'index_users_on_email', unique: true
    t.index ['reset_password_token'], name: 'index_users_on_reset_password_token', unique: true
  end

  add_foreign_key 'applies', 'jobs'
  add_foreign_key 'applies', 'users'
  add_foreign_key 'comments', 'headhunters'
  add_foreign_key 'comments', 'profiles'
  add_foreign_key 'feedback_applies', 'applies'
  add_foreign_key 'feedback_applies', 'headhunters'
  add_foreign_key 'jobs', 'companies'
  add_foreign_key 'jobs', 'countries'
  add_foreign_key 'profiles', 'countries'
  add_foreign_key 'profiles', 'users'
  add_foreign_key 'proposal_comments', 'proposals'
  add_foreign_key 'proposals', 'applies'
  add_foreign_key 'stars', 'applies'
  add_foreign_key 'stars', 'headhunters'
end
