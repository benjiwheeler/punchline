# a single judgement about a single punch; may have been made as part of a broader vote_decision
class Vote < ActiveRecord::Base
  belongs_to :vote_decision
  belongs_to :punch
  
  after_create :num_votes_increment
  
  def num_votes_increment
    $redis.incrby("meme:#{vote_decision.meme.tag}:user:#{vote_decision.user.id}:votes", 1)
  end

  def is_unrepeatable?
    !self.is_repeatable
  end

  def mark_repeatable
    self.is_repeatable = true
    self.save
  end
end
