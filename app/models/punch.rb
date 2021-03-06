class Punch < ActiveRecord::Base
  belongs_to :user
  belongs_to :meme
  has_one :tweet # don't destroy; tweet can still matter for rating users
  has_many :votes, dependent: :destroy
  before_save :init

  def Punch.min_score_to_show
    -10.0
  end

  def Punch.create_from_twitter_info(twitter_info)
    newpunch = Punch.new
    newpunch.tweet = Tweet.create_from_twitter_info(twitter_info)
    if newpunch.tweet.present?
      newpunch
    else
      nil
    end
  end

  def showable_to_user?(user)
    is_valid? && new_to_user?(user) && (get_generated_score > Punch.min_score_to_show)
  end


  def cleaned_text
    return '' if tweet.blank?
    messy_text = tweet.text

#    if true
#      messy_text = "#{messy_text} [#{self.get_generated_score}]"
#    end


#    if messy_text.nil?
#      binding.pry
#    end
    messy_text = CGI.unescapeHTML messy_text
    # remove this hash tag itself
    messy_text = messy_text.gsub(/\#?#{self.meme.tag_with_pound}\:?\s*/i, "")
    # remove usernames
    messy_text = messy_text.gsub(/@\S+\s*/i, "")
#    messy_text.gsub(/#replaceabookwithabeard/i, "")
#    messy_text.gsub!(/beard/i, "")

    messy_text
  end

  def is_valid?
    text_is_valid?
  end

  def text_is_valid?
    temp_text = self.cleaned_text
    return false if temp_text =~ %r!https?\://! # no links
    return false if temp_text =~ /\A\s*\Z/ # no blank entries
    logger.info "punch #{self.id} has score #{self.score}"
    logger.info "punch #{self.id} is valid"
    logger.info "cleaned text: #{temp_text}"
    true
  end

  def generate_score!
    self.generate_score
    self.save
  end

  def generate_score
    # binding.pry
    user_score = self.tweet.twitter_user.get_generated_score
    tweet_validity_score = self.text_is_valid? ? 0 : -50
    vote_score = 0
    if self.votes.any?
      self.votes.each do |vote|
        vote_score += vote.value
      end
    end
    self.score = user_score + vote_score + tweet_validity_score
  end
  
  def get_generated_score(args={})
    force_new_score = false
    if force_new_score or self.score.nil?
      self.generate_score(args)
      save
    end

    # add random element
    random_score = 0
    randomize = args.key?(:randomize) ? args[:randomize] : false    
    if randomize # gen val between 0 and 10, with half the values below 2.5
      rand_val = rand(100)
      long_tail_rand_val = (rand_val * rand_val / 10000.0)
      random_score = long_tail_rand_val * 10.0      
    end

    self.score + random_score
  end
  
  def init
    self.generate_score
  end
  
  def new_to_user?(user_in_question)
    assert user_in_question.present?, "User missing"
    user_in_question.could_vote_on_punch?(self)
  end
end
