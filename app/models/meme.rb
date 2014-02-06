# encoding: utf-8
class Meme < ActiveRecord::Base
  has_many :punches, dependent: :destroy
  has_many :vote_decisions, dependent: :destroy
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

  def good_num_session_punches_left?(user, num_punches_seen_in_session=0)
    num_punches_seen_in_session < Meme.max_punches_per_meme_per_session and \
      good_num_unseen_punches_left?(user)
  end

  def good_num_unseen_punches_left?(user)
    self.num_punches_fresh_to_user(user) >= Meme.min_punches_per_meme_per_session
  end

  def punches_sorted_by_score
    sorted_punches = self.punches.sort_by { |punch| punch.get_generated_score(randomize: true) }.reverse
    #binding.pry
    sorted_punches
  end

  def Meme.summarize_for_user(user)
    Meme.all.each do |meme|
      logger.debug "Meme: #{meme.id} text: #{meme.tag} punches: #{meme.punches.count} fresh punches: #{meme.num_punches_fresh_to_user(user)}"
    end
  end

  def Meme.sorted_by_score_for_user(user)
#    sorted_memes = Meme.all.sort_by { |meme| meme.get_generated_score }.reverse
    sorted_memes = Meme.all.find_all{|meme| meme.good_num_unseen_punches_left?(user)}.sort_by { |meme| [meme.num_votes_by(user), -meme.num_punches_fresh_to_user(user)] }
    sorted_memes
  end

  def Meme.max_punches_per_meme_per_session
    9
  end

  def Meme.min_punches_per_meme_per_session
    3
  end
  
  def num_punches_fresh_to_user(user)
    num_new = 0
    logger.debug "fresh_punches(#{user.name}, #{self.tag}): "
    self.punches.each do |punch|
      logger.debug "  punch: #{punch.tweet.text.truncate(10)} is new to user?"
      is_new = punch.showable_to_user?(user)
      num_new += 1 if is_new
      logger.debug "#{is_new} (#{num_new} now)"
    end
#    self.punches.find_all { |punch| punch.new_to_user?(user) }.count
    logger.debug "total new: #{num_new}"
    num_new
  end

  def Meme.n_best_memes_fresh_to_user(user, count, args={})
    exclude_list = args.key?(:exclude) ? args[:exclude] : []
    best_memes = Array.new
    sorted_memes = Meme.sorted_by_score_for_user(user)
    return nil if sorted_memes.blank?
    sorted_memes.each do |meme|
      if meme.good_num_unseen_punches_left?(user) and \
             !exclude_list.include?(meme)
        best_memes.push meme
        break if best_memes.count >= count
      end
    end
#    binding.pry
    best_memes.count == count ? best_memes : nil    
  end

  def n_best_punches_fresh_to_user(user, count)
    logger.debug "n_best_punches(#{user.name}, #{self.tag}): "
    assert user.present?, "User missing"
    best_punches = Array.new
    sorted_punches = punches_sorted_by_score
    logger.debug "  total punches in this meme: #{sorted_punches.count}"
    sorted_punches.each do |punch|
      if punch.showable_to_user?(user)
        best_punches.push punch
        break if best_punches.count >= count
      end
    end
#    binding.pry
    best_punches.count == count ? best_punches : nil
  end    

  def self.memes_fresh_to_user(user)
    Meme.sorted_by_score_for_user(user)
  end

  def twitter_client # NOTE: can this be static to the class?
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
    50
  end

  def Meme.max_scratch_tweets_to_fetch
    100
  end

  def pull_tweets
    # note that result_type = popular turns up very little content
    opts = { :count => Meme.max_scratch_tweets_to_fetch, :result_type => 'mixed' }
#    opts[:since_id] = self.last_tweet_id if self.punches.any?

    #client.search(HASHTAG, opts).each { |tweet| Tweet.create_from_tweet(tweet) }
    num_tweets_tried_to_add = 0
    self.twitter_client.search("\##{self.tag}", \
        opts).each.with_index(1) do |twitter_info, i|
      break if num_tweets_tried_to_add > Meme.max_tweets_to_fetch
      next if twitter_info.retweeted_status.present? # skip retweets
      new_punch = Punch.create_from_twitter_info(twitter_info) # nil if tweet already exists!
      if new_punch.present?
        self.punches.push new_punch 
        num_tweets_tried_to_add += 1
      end
    end
  end

  def generate_scores!
    self.punches.each {|punch| punch.generate_score!}
  end
  
end
