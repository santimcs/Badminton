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

ActiveRecord::Schema.define(version: 20161204070833) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "countries", force: :cascade do |t|
    t.string "name"
    t.string "flag"
  end

  create_table "entries", id: false, force: :cascade do |t|
    t.integer "tournament_id"
    t.integer "team_id"
    t.integer "rank"
    t.index ["team_id"], name: "index_entries_on_team_id", using: :btree
    t.index ["tournament_id", "team_id"], name: "index_entries_on_tournament_id_and_team_id", unique: true, using: :btree
    t.index ["tournament_id"], name: "index_entries_on_tournament_id", using: :btree
  end

  create_table "events", force: :cascade do |t|
    t.string  "abbr"
    t.string  "name"
    t.integer "no_of_players"
    t.integer "sequence"
  end

  create_table "matches", force: :cascade do |t|
    t.integer  "tournament_id"
    t.date     "date"
    t.integer  "round_id"
    t.integer  "team1_id"
    t.integer  "team2_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["round_id"], name: "index_matches_on_round_id", using: :btree
    t.index ["tournament_id"], name: "index_matches_on_tournament_id", using: :btree
  end

  create_table "players", force: :cascade do |t|
    t.string  "first_name"
    t.string  "last_name"
    t.integer "country_id"
    t.string  "image"
    t.string  "jersey_name"
    t.index ["country_id"], name: "index_players_on_country_id", using: :btree
  end

  create_table "results", force: :cascade do |t|
    t.integer  "match_id"
    t.integer  "game11",     default: 0
    t.integer  "game12",     default: 0
    t.integer  "game21",     default: 0
    t.integer  "game22",     default: 0
    t.integer  "game31"
    t.integer  "game32"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["match_id"], name: "index_results_on_match_id", using: :btree
  end

  create_table "rounds", force: :cascade do |t|
    t.string  "name"
    t.integer "sequence"
  end

  create_table "teams", force: :cascade do |t|
    t.integer "event_id"
    t.integer "player1_id"
    t.integer "player2_id"
    t.index ["event_id"], name: "index_teams_on_event_id", using: :btree
  end

  create_table "tournaments", force: :cascade do |t|
    t.string  "name"
    t.date    "fm_date"
    t.date    "to_date"
    t.integer "country_id"
    t.boolean "chosen",      default: false
    t.integer "category_id"
    t.index ["country_id"], name: "index_tournaments_on_country_id", using: :btree
  end

  add_foreign_key "entries", "teams"
  add_foreign_key "entries", "tournaments"
  add_foreign_key "matches", "rounds"
  add_foreign_key "matches", "tournaments"
  add_foreign_key "players", "countries"
  add_foreign_key "results", "matches"
  add_foreign_key "teams", "events"
  add_foreign_key "tournaments", "countries"
end
