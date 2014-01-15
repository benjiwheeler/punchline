#!/usr/bin/env ruby

HASHTAG = "#code2013"

# A script to import a backlog of tweets with the #{HASHTAG} hashtag. Uses the
# Twitter Search API to fetch a number of tweets containing the hashtag, then
# persists those to the database with DataMapper.
require 'twitter'

# Setup configuration and connect to database
require './lib/config.rb'

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV["HASHCODE_CONSUMER_KEY"]
  config.consumer_secret     = ENV["HASHCODE_CONSUMER_SECRET"]
  config.access_token        = ENV["HASHCODE_ACCESS_TOKEN"]
  config.access_token_secret = ENV["HASHCODE_ACCESS_SECRET"]
end

opts = { :count => 100, :result_type => 'recent' }
opts[:since_id] = Tweet.last_tweet_id if Tweet.any?

client.search(HASHTAG, opts).each do |tweet| 
  Meme.add_tweet_from_twitter_info(HASHTAG, tweet)
end
#firstTweet = client.search(HASHTAG, opts).first
#Tweet.create_from_twitter_info(firstTweet)
