class Meme < ActiveRecord::Base
  has_many :tweets
  validates :tag, presence: true
  validates_uniqueness_of :tag
  
  def last_tweet_id
    last_tweet = self.tweets.last
    return nil unless last_tweet
    Integer(last_tweet.tweet_id)    
  end
  
  def Meme.find_or_create(hashtag)
    meme = Meme.where(tag: hashtag).first
    meme ||= Meme.create!(tag: hashtag)
    raise "Couldn't create Meme with hashtag #{hashtag}" unless meme
    meme
  end
  
  def tweets_sorted_by_score
    sorted_tweets = self.tweets.sort_by { |tweet| tweet.get_generated_score }.reverse
    #binding.pry
    sorted_tweets
  end

  def twitter_client
    @client ||= Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["TWITTER_CONSUMER_KEY"]
      config.consumer_secret     = ENV["TWITTER_CONSUMER_SECRET"]
      config.access_token        = ENV["TWITTER_ACCESS_TOKEN"]
      config.access_token_secret = ENV["TWITTER_ACCESS_SECRET"]
    end
  end
  
  MAX_TWEETS_TO_FETCH = 10
  def pull_tweets
    opts = { :count => MAX_TWEETS_TO_FETCH, :result_type => 'recent' }
    opts[:since_id] = self.last_tweet_id if self.tweets.any?

    #client.search(HASHTAG, opts).each { |tweet| Tweet.create_from_tweet(tweet) }
    self.twitter_client.search("\##{self.tag}", \
        opts).each.with_index(1) do |tweet, i|
      break if i > MAX_TWEETS_TO_FETCH
      Tweet.create_from_twitter_info!(tweet, self.tag)
    end
  end
  
end
