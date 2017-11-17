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

ActiveRecord::Schema.define(version: 20171117060610) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "group", force: :cascade do |t|
    t.string "name"
    t.string "group_type"
    t.integer "location_id"
    t.integer "info_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "info", force: :cascade do |t|
    t.string "link"
    t.integer "members"
    t.boolean "is_regional"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "location", force: :cascade do |t|
    t.decimal "lat"
    t.decimal "lon"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "submitted_group", force: :cascade do |t|
    t.string "name"
    t.string "type"
    t.decimal "lat"
    t.decimal "lon"
    t.string "link"
    t.integer "members"
    t.boolean "is_regional"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "submitted_group_history", force: :cascade do |t|
    t.string "name"
    t.string "type"
    t.decimal "lat"
    t.decimal "lon"
    t.string "link"
    t.integer "members"
    t.boolean "is_regional"
    t.datetime "verified_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
