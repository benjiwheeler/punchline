#
#
class Tweet < ActiveRecord::Base
  belongs_to :punch, dependent: :destroy
  belongs_to :twitter_user
  validates :text, uniqueness: true

  def to_s
    # binding.pry
    text = self.attrs['text']
    # binding.pry
    name = self.attrs['user']['name']
    screen_name = self.attrs['user']['screen_name']
    "score: #{self.score} #{name} (@#{screen_name}): #{text} [Created #{created_in_twitter_at}]"
  end
  
  def text_is_valid?
    Tweet.text_is_valid?(text)
  end

  def self.text_is_valid?(text)
    return false if text =~ %r!https?\://! # no links
    return false if text =~ /\A\s*\Z/ # no blank entries
    true
  end

  # Public: Creates a CachedTweet from a Tweet object
  #
  # tweet - the tweet to cache
  #
  # Returns the new CachedTweet
  def self.create_from_twitter_info(tweet, twitter_user_author = nil)
    #json_attrs = JSON.parse(tweet.attrs.to_json, {:symbolize_names => true})
#    binding.pry

    # don't duplicate tweets. but do update them with info that changes over time
    existing_tweet = Tweet.where(tweet_id: tweet.id.to_s).first
    if existing_tweet.present?
      existing_tweet.update(
                   retweet_count: tweet.retweet_count.present? ? tweet.retweet_count : 0, 
                   favorite_count: tweet.favorite_count.present? ? tweet.favorite_count : 0
      )
    end

    return nil if !Tweet.text_is_valid?(tweet.text)

    twitter_user_author ||= TwitterUser.create_from_twitter_info!(tweet.user)
    
    new_tweet = Tweet.new(
    :tweet_id   => tweet.id.to_s,
    # need to do the following rval instead of just tweet.attrs in order to have symbols as keys in attrs. otherwise they are strings.
    :attrs      => tweet.attrs,
text: tweet.text,
                  twitter_user_id: twitter_user_author.id,
    :created_in_twitter_at => tweet.created_at,
      retweet_count: tweet.retweet_count.present? ? tweet.retweet_count : 0, 
      favorite_count: tweet.favorite_count.present? ? tweet.favorite_count : 0
    )
    if new_tweet.valid?
      new_tweet.save 
      new_tweet
    else
      nil
    end
  end

  # Public: Indicates whether cached tweets exist in the database or not
  #
  # Returns a boolean
  def self.any?
    Tweet.count > 0 ? true : false
  end

  # Public: Returns the ID of the last tweet persisted to the database
  #
  # Returns an integer
  def self.last_tweet_id
    return nil unless Tweet.any?
    Tweet.last.tweet_id
  end
end
   
