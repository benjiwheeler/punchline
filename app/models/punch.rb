class Punch < ActiveRecord::Base
  belongs_to :user
  belongs_to :meme
  has_one :tweet # don't destroy; tweet can still matter for rating users
  has_many :votes, dependent: :destroy
  after_save :init

  def Punch.create_from_twitter_info!(twitter_info)
    newpunch = Punch.new
    newpunch.tweet = Tweet.create_from_twitter_info!(twitter_info)
    newpunch
  end

  def cleaned_text
    messy_text = tweet.blank? ? "not available" : tweet.text
#    return self.meme.tag_with_pound
#    messy_text.gsub!(/#{self.meme.tag_with_pound}/i, "")
    messy_text.gsub!(/#replaceabookwithabeard/i, "")
#    messy_text.gsub!(/beard/i, "")
#    messy_text
  end

  def generate_score
    # binding.pry
    self.score = self.tweet.twitter_user.get_generated_score
  end
  
  def get_generated_score
    force_new_score = true
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
    !user_in_question.has_voted_on_punch?(self)
  end
end
