# encoding: utf-8
class Meme < ActiveRecord::Base
  has_many :punches
  validates :tag, presence: true
  validates_uniqueness_of :tag
  
  def last_tweet_id
    last_punch = self.punches.last
    return nil unless last_punch
    Integer(last_punch.tweet.tweet_id)    
  end
  
  def Meme.find_or_create(hashtag)
    meme = Meme.where(tag: hashtag).first
    meme ||= Meme.create!(tag: hashtag)
    raise "Couldn't create Meme with hashtag #{hashtag}" unless meme
    meme
  end
  
  def tag_with_pound
    self.tag if /\A\#/.match(self.tag)
    "#" + self.tag
  end

  def pretty_tag
    pound_tag = self.tag_with_pound
#    pound_tag.camelize
  end

  def num_votes_by(user)
    num_votes = 0
    self.punches.each do |punch|
      num_votes += user.votes.where(punch_id: punch.id).count
    end
    num_votes
  end

  def good_num_punches_left(user, num_punches_seen_in_session)
#    binding.pry
    num_punches_seen_ever = self.num_votes_by(user)
    num_punches_unseen = self.punches.count - num_punches_seen_ever
    num_punches_seen_in_session < Meme.max_punches_per_meme_per_session \
        and num_punches_unseen > Meme.min_punches_per_meme_per_session
  end

  def punches_sorted_by_score
    sorted_punches = self.punches.sort_by { |punch| punch.get_generated_score }.reverse
    #binding.pry
    sorted_punches
  end

  def Meme.sorted_by_score_for_user(user)
    sorted_memes = Meme.all.shuffle #.sort_by { |meme| meme.get_generated_score }.reverse
    sorted_memes
  end

  def Meme.max_punches_per_meme_per_session
    9
  end

  def Meme.min_punches_per_meme_per_session
    3
  end
  
  def punches_fresh_to_user(user, num_punches)
    assert user.present?, "User missing"
    best_punches = Array.new
    sorted_punches = punches_sorted_by_score
    sorted_punches.each do |punch|
      if punch.new_to_user?(user)
        best_punches.push punch
        break if best_punches.count >= num_punches
      end
    end
    best_punches
  end    

  def twitter_client
    @client ||= Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["TWITTER_CONSUMER_KEY"]
      config.consumer_secret     = ENV["TWITTER_CONSUMER_SECRET"]
      config.access_token        = ENV["TWITTER_ACCESS_TOKEN"]
      config.access_token_secret = ENV["TWITTER_ACCESS_SECRET"]
    end
  end
  
  def Meme.add_tweet_from_twitter_info(hashtag, twitter_info)
    meme = Meme.find_or_create(hashtag)
#    punch = meme.punches.find_from_twitter_info(twitter_info)
#    if punch.nil?
    meme.punches.push Punch.create_from_twitter_info!(twitter_info)
 #   end
  end

  def Meme.max_tweets_to_fetch
    10
  end

  def pull_tweets
    # note that result_type = popular turns up very little content
    opts = { :count => Meme.max_tweets_to_fetch, :result_type => 'recent' }
    opts[:since_id] = self.last_tweet_id if self.punches.any?

    #client.search(HASHTAG, opts).each { |tweet| Tweet.create_from_tweet(tweet) }
    self.twitter_client.search("\##{self.tag}", \
        opts).each.with_index(1) do |twitter_info, i|
      break if i > Meme.max_tweets_to_fetch
      next if twitter_info.retweeted_status.present? # skip retweets
      self.punches << Punch.create_from_twitter_info!(twitter_info)
    end
  end
  
end
