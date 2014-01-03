class Tweet < ActiveRecord::Base
  belongs_to :meme
  after_save :init
  
  def to_s
    #binding.pry
    text = self.attrs["text"]
    #binding.pry
    name = self.attrs["user"]["name"]
    screen_name = self.attrs["user"]["screen_name"]
    "score: #{self.score} #{name} (@#{screen_name}): #{text} [Created #{created_in_twitter_at}]"
  end
  
  def generate_score
  # binding.pry
    self.score = self.followers + self.friends
  end
  
  def get_generated_score
    force_new_score = false
    if force_new_score or self.score.nil?
      self.generate_score
      save
    end
    self.score
  end
  
  def init
    self.generate_score
  end
  
  # Public: Creates a CachedTweet from a Tweet object
  #
  # tweet - the tweet to cache
  #
  # Returns the new CachedTweet
  def Tweet.create_from_twitter_info!(tweet, hashtag)
    meme = Meme.where(tag: hashtag).first
    meme ||= Meme.create!(tag: hashtag)
    raise "Couldn't create Meme with hashtag #{hashtag}" unless meme

    #json_attrs = JSON.parse(tweet.attrs.to_json, {:symbolize_names => true})
    #binding.pry

    meme.tweets.create!(
    :tweet_id   => tweet.id,
    # need to do the following rval instead of just tweet.attrs in order to have symbols as keys in attrs. otherwise they are strings.
    :attrs      => tweet.attrs,
    user_real_name: tweet.attrs[:user][:name],
    user_screen_name: tweet.attrs[:user][:screen_name],
    followers: tweet.attrs[:user][:followers_count],
    friends: tweet.attrs[:user][:friends_count],
    statuses_count: tweet.attrs[:user][:statuses_count],
    :created_in_twitter_at => tweet.created_at
    )
  end

  # Public: Indicates whether cached tweets exist in the database or not
  #
  # Returns a boolean
  def Tweet.any?
    Tweet.count > 0 ? true : false
  end

  # Public: Returns the ID of the last tweet persisted to the database
  #
  # Returns an integer
  def Tweet.last_tweet_id
    return nil unless Tweet.any?
    Integer(Tweet.last.tweet_id)
  end
end
