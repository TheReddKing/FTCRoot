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

ActiveRecord::Schema.define(version: 20161215153318) do

  create_table "event_migrations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "migration_date"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "league_meet_event_teams", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "league_meet_event_id"
    t.integer  "teamid"
    t.string   "alliance"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.index ["league_meet_event_id"], name: "index_league_meet_event_teams_on_league_meet_event_id", using: :btree
  end

  create_table "league_meet_events", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "league_meet_id"
    t.integer  "redscore"
    t.integer  "redauto"
    t.integer  "redteleop"
    t.integer  "redend"
    t.integer  "redpenalty"
    t.integer  "bluescore"
    t.integer  "blueauto"
    t.integer  "blueteleop"
    t.integer  "blueend"
    t.integer  "bluepenalty"
    t.integer  "order"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "name"
    t.index ["league_meet_id"], name: "index_league_meet_events_on_league_meet_id", using: :btree
  end

  create_table "league_meets", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "date"
    t.text     "description", limit: 65535
    t.string   "location"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
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
    t.float    "location_lat",  limit: 24
    t.float    "location_long", limit: 24
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

end
