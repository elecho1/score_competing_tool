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

ActiveRecord::Schema.define(version: 20171117144304) do

  create_table "labs", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.integer  "capacity",   limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "url",        limit: 255
  end

  create_table "scores", force: :cascade do |t|
    t.integer  "user_score_id", limit: 4, null: false
    t.integer  "subject_id",    limit: 4, null: false
    t.integer  "value",         limit: 4
    t.boolean  "registered",              null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "scores", ["user_score_id", "subject_id"], name: "index_scores_on_user_score_id_and_subject_id", unique: true, using: :btree

  create_table "semester_scores", force: :cascade do |t|
    t.integer  "user_score_id", limit: 4,                null: false
    t.integer  "semester",      limit: 4,                null: false
    t.float    "total_score",   limit: 24, default: 0.0, null: false
    t.float    "gpa",           limit: 24, default: 0.0, null: false
    t.float    "score_count",   limit: 24, default: 0.0, null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  create_table "subjects", force: :cascade do |t|
    t.string   "key",          limit: 255, null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.float    "weight",       limit: 24,  null: false
    t.integer  "semester",     limit: 4,   null: false
    t.string   "subject_type", limit: 255, null: false
  end

  create_table "user_scores", force: :cascade do |t|
    t.integer  "user_id",     limit: 4,                null: false
    t.float    "total_score", limit: 24,               null: false
    t.float    "gpa",         limit: 24, default: 0.0, null: false
    t.float    "score_count", limit: 24, default: 0.0, null: false
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: ""
    t.string   "encrypted_password",     limit: 255, default: "",      null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.string   "user_key",               limit: 255,                   null: false
    t.boolean  "open_user_name",                                       null: false
    t.boolean  "open_score",                                           null: false
    t.string   "user_name",              limit: 255
    t.string   "provider",               limit: 255
    t.string   "uid",                    limit: 255
    t.boolean  "slack_enabled_flag",                 default: false,   null: false
    t.string   "department",             limit: 255, default: "denjo", null: false
    t.integer  "lab_id",                 limit: 4
    t.boolean  "open_lab",                           default: false,   null: false
  end

  add_index "users", ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true, using: :btree

end
