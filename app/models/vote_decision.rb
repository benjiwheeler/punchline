# a single decision that involves one or more votes; eg, picking best of 3. 
class VoteDecision < ActiveRecord::Base
  belongs_to :user
  belongs_to :meme
  has_many :votes, dependent: :destroy
  accepts_nested_attributes_for :votes
  
  after_create :fresh_punches_decrement
  
  def fresh_punches_decrement
    $redis.decrby("meme:#{meme.tag}:user:#{user.id}:numfp", votes.count)
  end

  def deep_inspect
    str = "Vote decision: " + self.inspect
    votes.each do |vote|
      str += "vote: #{vote.inspect}"
    end
    str
  end

end
