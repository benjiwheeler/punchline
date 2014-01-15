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

ActiveRecord::Schema.define(version: 20140115211854) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authorizations", force: true do |t|
    t.string   "provider"
    t.string   "uid"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.string   "oauth_secret"
    t.string   "name"
    t.string   "screen_name"
    t.string   "nickname"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "location"
    t.string   "description"
    t.string   "image"
    t.string   "phone"
    t.json     "urls"
    t.json     "raw_info"
  end

  add_index "authorizations", ["user_id"], name: "index_authorizations_on_user_id", using: :btree

  create_table "hashtags", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "content"
  end

  create_table "memes", force: true do |t|
    t.string   "tag"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "memes", ["tag"], name: "index_memes_on_tag", using: :btree

  create_table "punches", force: true do |t|
    t.integer  "user_id"
    t.string   "text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "meme_id"
    t.float    "score"
  end

  add_index "punches", ["meme_id"], name: "index_punches_on_meme_id", using: :btree
  add_index "punches", ["user_id"], name: "index_punches_on_user_id", using: :btree

  create_table "tweets", force: true do |t|
    t.json     "attrs"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "created_in_twitter_at"
    t.integer  "punch_id"
    t.integer  "retweet_count"
    t.integer  "favorite_count"
    t.integer  "twitter_user_id"
    t.string   "tweet_id"
  end

  add_index "tweets", ["punch_id"], name: "index_tweets_on_punch_id", using: :btree
  add_index "tweets", ["twitter_user_id"], name: "index_tweets_on_twitter_user_id", using: :btree

  create_table "twitter_users", force: true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "screen_name"
    t.integer  "followers"
    t.integer  "friends"
    t.integer  "statuses_count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "score"
  end

  add_index "twitter_users", ["user_id"], name: "index_twitter_users_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "vote_decisions", force: true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "vote_decisions", ["user_id"], name: "index_vote_decisions_on_user_id", using: :btree

  create_table "votes", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "value"
    t.integer  "punch_id"
    t.integer  "vote_decision_id"
  end

  add_index "votes", ["punch_id"], name: "index_votes_on_punch_id", using: :btree
  add_index "votes", ["vote_decision_id"], name: "index_votes_on_vote_decision_id", using: :btree

end
