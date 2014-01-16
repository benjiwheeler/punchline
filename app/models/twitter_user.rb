class TwitterUser < ActiveRecord::Base
  belongs_to :user # but doesn't necessarily have any user
  has_many :tweets
  before_save :init

  def TwitterUser.create_from_twitter_info!(tweet_user_fields)
    twitter_user = TwitterUser.where(screen_name: tweet_user_fields.screen_name)
    if twitter_user.present?
      twitter_user = twitter_user.first
    else # no current twitter_user with that screen name
      twitter_user = TwitterUser.create!(
                                         name: tweet_user_fields.name,
                                         screen_name: tweet_user_fields.screen_name,
                                         followers: tweet_user_fields.followers_count,
                                         friends: tweet_user_fields.friends_count,
                                         statuses_count: tweet_user_fields.statuses_count
                                         )
    end
#    twitter_user.save if twitter_user.changed?
#    binding.pry
    twitter_user.link_to_user
    twitter_user
  end

  def link_to_user
    if self.user.nil?
      existing_user = User.find_with_twitter_screen_name(self.screen_name)
      if existing_user.present?
        self.user = existing_user
      end
    end
    self.save if self.changed?
  end

  def generate_score
    self.score = Math.log(self.followers) / Math.log(10)
    self.score += Math.log(self.friends) / Math.log(10)
    self.score += Math.log(self.statuses_count) / Math.log(10)
    self.score
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
  
end
