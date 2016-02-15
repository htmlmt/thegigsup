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

ActiveRecord::Schema.define(version: 20160215021200) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bands", force: :cascade do |t|
    t.string   "name"
    t.string   "website"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "songkick_id"
    t.integer  "event_id"
    t.string   "slug"
    t.text     "description"
    t.string   "twitter"
    t.string   "tags",        default: [],              array: true
    t.integer  "similars",    default: [],              array: true
    t.string   "video_link"
    t.string   "video_kind"
    t.string   "youtube_id"
    t.boolean  "headliner"
  end

  add_index "bands", ["slug"], name: "index_bands_on_slug", unique: true, using: :btree

  create_table "bands_events", id: false, force: :cascade do |t|
    t.integer "band_id"
    t.integer "event_id"
  end

  add_index "bands_events", ["band_id", "event_id"], name: "index_bands_events_on_band_id_and_event_id", using: :btree

  create_table "events", force: :cascade do |t|
    t.integer  "facebook_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "songkick_id"
    t.integer  "band_id"
    t.integer  "venue_id"
    t.datetime "start"
    t.string   "poster_file_name"
    t.string   "poster_content_type"
    t.integer  "poster_file_size"
    t.datetime "poster_updated_at"
    t.string   "ticket_link"
    t.string   "songkick_link"
    t.integer  "headliner"
    t.integer  "supporting_acts",     default: [],              array: true
    t.integer  "headliners",          default: [],              array: true
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "reposts", force: :cascade do |t|
    t.integer  "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",            null: false
    t.string   "crypted_password"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

  create_table "venues", force: :cascade do |t|
    t.string   "name"
    t.string   "city"
    t.string   "street"
    t.integer  "zip"
    t.string   "website"
    t.float    "longitude"
    t.float    "latitude"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "songkick_id"
    t.string   "slug"
    t.text     "description"
    t.string   "links",       default: [],              array: true
  end

  add_index "venues", ["slug"], name: "index_venues_on_slug", unique: true, using: :btree

end
