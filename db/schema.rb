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

ActiveRecord::Schema.define(version: 20150706221346) do

  create_table "categorables", force: :cascade do |t|
    t.integer "category_id",      limit: 4
    t.string  "categorable_type", limit: 255
    t.integer "categorable_id",   limit: 4
  end

  create_table "categories", force: :cascade do |t|
    t.string  "name",      limit: 255
    t.integer "master_id", limit: 4
  end

  create_table "comments", force: :cascade do |t|
    t.text     "body",             limit: 65535
    t.integer  "user_id",          limit: 4
    t.string   "commentable_type", limit: 255
    t.integer  "commentable_id",   limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "group_id",         limit: 4
    t.integer  "votes_count",      limit: 4,     default: 0
  end

  create_table "gategorables", force: :cascade do |t|
    t.integer "gategory_id",      limit: 4
    t.string  "gategorable_type", limit: 255
    t.integer "gategorable_id",   limit: 4
  end

  create_table "gategories", force: :cascade do |t|
    t.string  "name",       limit: 255
    t.integer "master_id",  limit: 4
    t.integer "group_id",   limit: 4
    t.integer "gmaster_id", limit: 4
  end

  create_table "groups", force: :cascade do |t|
    t.string "school", limit: 255
    t.string "state",  limit: 255
    t.string "city",   limit: 255
  end

  create_table "images", force: :cascade do |t|
    t.string   "title",       limit: 255
    t.text     "description", limit: 65535
    t.integer  "user_id",     limit: 4
    t.integer  "group_id",    limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "views",       limit: 4,     default: 0
    t.integer  "votes_count", limit: 4,     default: 0
    t.text     "tag",         limit: 65535
  end

  create_table "impressions", force: :cascade do |t|
    t.string   "impressionable_type", limit: 255
    t.integer  "impressionable_id",   limit: 4
    t.integer  "user_id",             limit: 4
    t.string   "controller_name",     limit: 255
    t.string   "action_name",         limit: 255
    t.string   "view_name",           limit: 255
    t.string   "request_hash",        limit: 255
    t.string   "ip_address",          limit: 255
    t.string   "session_hash",        limit: 255
    t.text     "message",             limit: 65535
    t.text     "referrer",            limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "impressions", ["controller_name", "action_name", "ip_address"], name: "controlleraction_ip_index", using: :btree
  add_index "impressions", ["controller_name", "action_name", "request_hash"], name: "controlleraction_request_index", using: :btree
  add_index "impressions", ["controller_name", "action_name", "session_hash"], name: "controlleraction_session_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "ip_address"], name: "poly_ip_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "request_hash"], name: "poly_request_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "session_hash"], name: "poly_session_index", using: :btree
  add_index "impressions", ["impressionable_type", "message", "impressionable_id"], name: "impressionable_type_message_index", length: {"impressionable_type"=>nil, "message"=>255, "impressionable_id"=>nil}, using: :btree
  add_index "impressions", ["user_id"], name: "index_impressions_on_user_id", using: :btree

  create_table "my_classes", force: :cascade do |t|
    t.integer "user_id",        limit: 4
    t.string  "classable_type", limit: 255
    t.integer "classable_id",   limit: 4
  end

  create_table "notifications", force: :cascade do |t|
    t.string   "postable_type",    limit: 255
    t.integer  "postable_id",      limit: 4
    t.integer  "reciever_id",      limit: 4
    t.integer  "sender_id",        limit: 4
    t.string   "notificable_type", limit: 255
    t.integer  "notificable_id",   limit: 4
    t.boolean  "checked",          limit: 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "checked_at"
  end

  create_table "pictures", force: :cascade do |t|
    t.integer  "image_id",           limit: 4
    t.string   "photo_file_name",    limit: 255
    t.string   "photo_content_type", limit: 255
    t.integer  "photo_file_size",    limit: 4
    t.datetime "photo_updated_at"
  end

  create_table "questions", force: :cascade do |t|
    t.string   "title",       limit: 255
    t.text     "description", limit: 65535
    t.integer  "user_id",     limit: 4
    t.integer  "group_id",    limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "answered",    limit: 1
    t.integer  "views",       limit: 4,     default: 0
    t.integer  "votes_count", limit: 4,     default: 0
  end

  create_table "users", force: :cascade do |t|
    t.string   "username",        limit: 255
    t.string   "password_digest", limit: 255
    t.integer  "group_id",        limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "votes_count",     limit: 4,   default: 0
  end

  create_table "votes", force: :cascade do |t|
    t.boolean  "vote",          limit: 1
    t.integer  "user_id",       limit: 4
    t.string   "voteable_type", limit: 255
    t.integer  "voteable_id",   limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
