class Hashtag < ActiveRecord::Base
  has_many :tweets
  validates :content, presence: true

  
end
