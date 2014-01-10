class User < ActiveRecord::Base
  has_many :authorizations, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, \
         :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable, :omniauth_providers => [:facebook, :twitter]
  
  def to_s
    self.name
  end
  
  def name
    self.authorizations.each do |auth|
      return auth.name unless auth.name.blank?
    end
    self.authorizations.each do |auth|
      return auth.screen_name unless auth.screen_name.blank?
    end
    self.authorizations.each do |auth|
      return auth.nickname unless auth.nickname.blank?
    end
    return self.email unless self.email.blank?
    return "Guest"
  end
  
  def self.find_from_oauth(oauth_params)
    find_by_email(oauth_params.info.email)
  end

  def self.create_from_oauth!(oauth_params)
#    binding.pry
    newuser = User.new
    newuser.email = oauth_params.info.email if oauth_params.info.email # not sure what the deal is with this
    newuser.password = Devise.friendly_token[0,20] # not sure what the deal is with this
    newuser.save!(:validate => false) # don't worry about email
    newuser
  end
end
