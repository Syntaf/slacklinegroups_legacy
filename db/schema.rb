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

ActiveRecord::Schema.define(version: 20170916152748) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "groups", force: :cascade do |t|
    t.text "cords"
    t.string "name"
    t.integer "members"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "fb_group"
    t.decimal "centroid_lat"
    t.decimal "centroid_lon"
    t.string "order"
    t.string "country"
    t.string "fb_page"
    t.string "website"
    t.boolean "isRegional", default: false
  end

  create_table "user_submitted_groups", force: :cascade do |t|
    t.text "cords"
    t.string "name"
    t.integer "members"
    t.decimal "centroid_lat"
    t.decimal "centroid_lon"
    t.string "order"
    t.string "country"
    t.string "fb_group"
    t.string "fb_page"
    t.string "website"
    t.string "email"
    t.boolean "isRegional", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "approved", default: 0
  end

end
