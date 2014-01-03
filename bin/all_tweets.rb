#!/usr/bin/env ruby

require 'twitter'

SEARCH_STR = "#helloworld"

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV["TWITTER_CONSUMER_KEY"]
  config.consumer_secret     = ENV["TWITTER_CONSUMER_SECRET"]
  config.access_token        = ENV["TWITTER_ACCESS_TOKEN"]
  config.access_token_secret = ENV["TWITTER_ACCESS_SECRET"]
end

opts = { :count => 10, :result_type => 'recent' }

client.search(SEARCH_STR, opts).each do |tweet| 
  text = tweet.attrs[:text]
  name = tweet.attrs[:user][:name]
  screen_name = tweet.attrs[:user][:screen_name]
  created_at = tweet.attrs[:created_at]
  puts "#{name} (@#{screen_name}): #{text} [Created #{created_at}]"
end

