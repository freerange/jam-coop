# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2023_11_22_152018) do
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
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "albums", force: :cascade do |t|
    t.string "title", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.bigint "artist_id", default: 1, null: false
    t.text "about"
    t.text "credits"
    t.boolean "published", default: false, null: false
    t.decimal "price", precision: 8, scale: 2, default: "7.0"
    t.date "released_at"
    t.integer "publication_status", default: 0, null: false
    t.index ["artist_id"], name: "index_albums_on_artist_id"
    t.index ["slug", "artist_id"], name: "index_albums_on_slug_and_artist_id", unique: true
  end

  create_table "artists", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.string "location"
    t.string "description"
    t.bigint "user_id"
    t.index ["slug"], name: "index_artists_on_slug", unique: true
    t.index ["user_id"], name: "index_artists_on_user_id"
  end

  create_table "downloads", force: :cascade do |t|
    t.integer "format"
    t.bigint "album_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["album_id"], name: "index_downloads_on_album_id"
  end

  create_table "email_verification_tokens", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_email_verification_tokens_on_user_id"
  end

  create_table "interests", force: :cascade do |t|
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "email_confirmed", default: false, null: false
    t.string "confirm_token"
    t.datetime "sending_suppressed_at"
    t.index ["email"], name: "index_interests_on_email", unique: true
  end

  create_table "password_reset_tokens", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_password_reset_tokens_on_user_id"
  end

  create_table "purchases", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "album_id"
    t.decimal "price", precision: 8, scale: 2
    t.boolean "contact_opt_in", default: false, null: false
    t.string "stripe_session_id"
    t.boolean "completed", default: false, null: false
    t.string "customer_email"
    t.index ["album_id"], name: "index_purchases_on_album_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "user_agent"
    t.string "ip_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "tracks", force: :cascade do |t|
    t.string "title"
    t.integer "position"
    t.bigint "album_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "original_data"
    t.index ["album_id"], name: "index_tracks_on_album_id"
  end

  create_table "transcodes", force: :cascade do |t|
    t.bigint "track_id"
    t.integer "format", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["format", "track_id"], name: "index_transcodes_on_format_and_track_id", unique: true
    t.index ["track_id"], name: "index_transcodes_on_track_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.boolean "verified", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "sending_suppressed_at"
    t.boolean "admin", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "albums", "artists"
  add_foreign_key "artists", "users"
  add_foreign_key "downloads", "albums"
  add_foreign_key "email_verification_tokens", "users"
  add_foreign_key "password_reset_tokens", "users"
  add_foreign_key "purchases", "albums"
  add_foreign_key "sessions", "users"
end
