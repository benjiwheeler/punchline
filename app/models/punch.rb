class Punch < ActiveRecord::Base
  belongs_to :user
  belongs_to :meme
  has_one :tweet # don't destroy; tweet can still matter for rating users
  has_many :votes, dependent: :destroy
  before_save :init

  def Punch.create_from_twitter_info(twitter_info)
    newpunch = Punch.new
    newpunch.tweet = Tweet.create_from_twitter_info(twitter_info)
    if newpunch.tweet.present?
      newpunch
    else
      nil
    end
  end

  def cleaned_text
    messy_text = tweet.blank? ? "not available" : tweet.text
#    return self.meme.tag_with_pound
    if messy_text.nil?
      binding.pry
    end
    messy_text = CGI.unescapeHTML messy_text
    messy_text = messy_text.gsub(/#{self.meme.tag_with_pound}\:?\s*/i, "")
    messy_text = messy_text.gsub(/@\S+\s*/i, "")
#    messy_text.gsub(/#replaceabookwithabeard/i, "")
#    messy_text.gsub!(/beard/i, "")
#    messy_text
  end

  def generate_score!
    self.generate_score
    self.save
  end

  def generate_score
    # binding.pry
    user_score = self.tweet.twitter_user.get_generated_score
    tweet_validity_score = self.tweet.text_is_valid? ? 0 : -50
    vote_score = 0
    if self.votes.any?
      self.votes.each do |vote|
        vote_score += vote.value
      end
    end
    self.score = user_score + vote_score + tweet_validity_score
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
  
  def new_to_user?(user_in_question)
    assert user_in_question.present?, "User missing"
    user_in_question.could_vote_on_punch?(self)
  end
end
