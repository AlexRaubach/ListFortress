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

ActiveRecord::Schema.define(version: 2018_11_21_020916) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
    t.integer "tier"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_identities_on_user_id"
  end

  create_table "league_participants", force: :cascade do |t|
    t.integer "user_id"
    t.integer "season_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "seasons", force: :cascade do |t|
    t.string "name"
    t.boolean "active"
    t.boolean "sign_up_active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ships", force: :cascade do |t|
    t.string "name"
    t.integer "ffg"
    t.string "size"
    t.integer "xws"
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
  end

  create_table "versions", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
