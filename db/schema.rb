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

ActiveRecord::Schema.define(version: 20170210194705) do

  create_table "event_migrations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "migration_date"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "events", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "region_id"
    t.string   "name"
    t.string   "date"
    t.string   "ftcmatchcode"
    t.text     "description",      limit: 65535
    t.string   "location"
    t.string   "competitiontype"
    t.text     "data_competition", limit: 65535
    t.boolean  "advanceddata"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.text     "data_stats",       limit: 65535
    t.string   "data_highscore"
    t.boolean  "advancedstats"
    t.text     "data_raw",         limit: 65535
    t.boolean  "advancedraw"
    t.index ["region_id"], name: "index_events_on_region_id", using: :btree
  end

  create_table "regions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.text     "website",    limit: 65535
    t.text     "info",       limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "team_assets", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "team_id"
    t.string   "content"
    t.string   "ctype"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_team_assets_on_team_id", using: :btree
  end

  create_table "teams", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "location"
    t.float    "location_lat",      limit: 24
    t.float    "location_long",     limit: 24
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "website"
    t.string   "contact"
    t.text     "data_competitions", limit: 65535
    t.text     "blurb",             limit: 65535
    t.string   "data_strong"
    t.string   "data_rootrank"
    t.string   "data_rootscore"
    t.string   "contact_email"
    t.string   "contact_twitter"
    t.string   "data_opr"
    t.string   "data_oprauto"
    t.string   "data_oprtele"
    t.string   "data_oprend"
    t.string   "contact_youtube"
    t.string   "contact_facebook"
  end

end
