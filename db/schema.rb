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

ActiveRecord::Schema.define(version: 2019_02_27_125129) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "addresses", force: :cascade do |t|
    t.integer "league_player_id"
    t.string "first_line"
    t.string "second_line"
    t.string "city"
    t.string "county_province"
    t.string "zip_or_postcode"
    t.string "country"
    t.boolean "use_other"
    t.string "other"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "divisions", force: :cascade do |t|
    t.string "name"
    t.integer "season_id"
    t.integer "tier"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "letter"
  end

  create_table "factions", force: :cascade do |t|
    t.string "name"
    t.string "xws"
    t.integer "ffg"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "formats", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "identities", force: :cascade do |t|
    t.string "uid"
    t.string "provider"
    t.bigint "user_id"
    t.index ["user_id"], name: "index_identities_on_user_id"
  end

  create_table "leage_matches", force: :cascade do |t|
    t.integer "p1_id"
    t.jsonb "p1_list_json"
    t.string "p1_lj_list_string"
    t.string "p1_list_url"
    t.integer "p2_id"
    t.jsonb "p2_list_json"
    t.string "p2_lj_list_string"
    t.string "p2_list_url"
    t.integer "division_id"
    t.integer "match_state_id"
    t.integer "legacy_match_id"
    t.date "scheduled_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "league_match_states", force: :cascade do |t|
    t.string "name"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "league_participants", force: :cascade do |t|
    t.integer "user_id"
    t.integer "division_id"
    t.integer "list_juggler_id"
    t.string "list_juggler_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "promotion"
    t.integer "league_match"
  end

  create_table "matches", force: :cascade do |t|
    t.string "player1_type"
    t.bigint "player1_id"
    t.integer "player1_points"
    t.jsonb "player1_xws"
    t.string "player2_type"
    t.bigint "player2_id"
    t.integer "player2_points"
    t.jsonb "player2_xws"
    t.string "winner_type"
    t.bigint "winner_id"
    t.bigint "round_id"
    t.string "result"
    t.string "logfile_url"
    t.integer "match_state"
    t.datetime "scheduled_time"
    t.boolean "extended"
    t.boolean "locked"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player1_type", "player1_id"], name: "index_matches_on_player1_type_and_player1_id"
    t.index ["player2_type", "player2_id"], name: "index_matches_on_player2_type_and_player2_id"
    t.index ["round_id"], name: "index_matches_on_round_id"
    t.index ["winner_type", "winner_id"], name: "index_matches_on_winner_type_and_winner_id"
  end

  create_table "participants", force: :cascade do |t|
    t.integer "tournament_id"
    t.string "name"
    t.integer "player_id"
    t.integer "score"
    t.integer "swiss_rank"
    t.integer "top_cut_rank"
    t.integer "mov"
    t.decimal "sos"
    t.boolean "dropped"
    t.integer "list_points"
    t.jsonb "list_json"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tournament_id"], name: "index_participants_on_tournament_id"
  end

  create_table "pilots", force: :cascade do |t|
    t.string "name"
    t.string "caption"
    t.integer "initiative"
    t.boolean "limited"
    t.integer "cost"
    t.string "xws"
    t.integer "ffg"
    t.integer "ship_id"
    t.string "image"
    t.string "ability"
    t.index ["xws"], name: "index_pilots_on_xws"
  end

  create_table "rounds", force: :cascade do |t|
    t.bigint "roundtype_id"
    t.integer "round_number"
    t.bigint "tournament_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["roundtype_id"], name: "index_rounds_on_roundtype_id"
    t.index ["tournament_id"], name: "index_rounds_on_tournament_id"
  end

  create_table "roundtypes", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "season_seven_surveys", force: :cascade do |t|
    t.integer "user_id"
    t.string "full_name"
    t.string "display_name"
    t.string "time_zone"
    t.integer "time"
    t.integer "s1_id"
    t.integer "s2_id"
    t.integer "s3_id"
    t.integer "s4_id"
    t.integer "s5_id"
    t.integer "s6_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "seasons", force: :cascade do |t|
    t.string "name"
    t.integer "season_number"
    t.boolean "active"
    t.boolean "sign_up_active"
    t.boolean "locked"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ships", force: :cascade do |t|
    t.string "name"
    t.integer "ffg"
    t.string "size"
    t.string "xws"
    t.integer "faction_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["xws"], name: "index_ships_on_xws"
  end

  create_table "tournament_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tournaments", force: :cascade do |t|
    t.string "name"
    t.integer "organizer_id"
    t.string "location"
    t.string "state"
    t.string "country"
    t.date "date"
    t.integer "format_id"
    t.integer "version_id"
    t.integer "tournament_type_id"
    t.boolean "locked"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "participants_count", default: 0, null: false
  end

  create_table "upgrades", force: :cascade do |t|
    t.string "name"
    t.string "xws"
    t.integer "ffg"
    t.string "upgrade_type"
    t.boolean "limited"
    t.string "image"
    t.integer "cost"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["xws"], name: "index_upgrades_on_xws"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slack_id"
    t.boolean "league_eligible"
    t.string "name"
    t.string "slack_avatar"
    t.boolean "admin"
    t.string "display_name"
  end

  create_table "versions", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "matches", "rounds"
  add_foreign_key "rounds", "roundtypes"
  add_foreign_key "rounds", "tournaments"
end
