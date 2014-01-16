# a single decision that involves one or more votes; eg, picking best of 3. 
class VoteDecision < ActiveRecord::Base
  belongs_to :user
  has_many :votes, dependent: :destroy

  accepts_nested_attributes_for :votes

  def deep_inspect
    str = "Vote decision: " + self.inspect
    votes.each do |vote|
      str += "vote: #{vote.inspect}"
    end
    str
  end
end
