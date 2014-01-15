# a single judgement about a single punch; may have been made as part of a broader vote_decision
class Vote < ActiveRecord::Base
  belongs_to :vote_decision
  belongs_to :punch
end
