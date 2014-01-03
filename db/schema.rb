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

ActiveRecord::Schema.define(version: 20140103215209) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  create_table "tweets", force: true do |t|
    t.string   "tweet_id"
    t.json     "attrs"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "created_in_twitter_at"
    t.integer  "meme_id"
    t.float    "score"
    t.string   "user_real_name"
    t.string   "user_screen_name"
    t.integer  "followers"
    t.integer  "friends"
    t.integer  "statuses_count"
  end

  add_index "tweets", ["meme_id"], name: "index_tweets_on_meme_id", using: :btree

end
