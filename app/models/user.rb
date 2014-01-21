class User < ActiveRecord::Base
  has_many :authorizations, dependent: :destroy
  has_many :vote_decisions, dependent: :destroy
  has_many :votes, through: :vote_decisions
  has_many :punches, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
#  devise :database_authenticatable, :registerable, \
#         :recoverable, :rememberable, :trackable, :validatable

  # NOTE: is this one still necessary, since we're not using authenticate_user?
  devise :database_authenticatable
  devise :rememberable, :trackable, :timeoutable
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

  def has_auth?(provider)
    self.authorizations.where(provider: provider.to_s).any?
  end

  def auth_field(provider, fieldname)
    return nil unless has_auth?(provider)
    self.authorizations.where(provider: provider.to_s).first.attributes[fieldname.to_s]
  end

  def User.find_from_oauth(oauth_params)
    find_by_email(oauth_params.info.email)
  end

  def User.create_from_oauth!(oauth_params)
#    binding.pry
    newuser = User.new
    newuser.email = oauth_params.info.email if oauth_params.info.email # not sure what the deal is with this
    newuser.password = Devise.friendly_token[0,20] # not sure what the deal is with this
    newuser.save!(:validate => false) # don't worry about email
    newuser
  end

  def could_vote_on_punch?(punch)
    has_unrepeatable_vote = false
    votes.where(punch_id: punch.id).each do |vote|
      if vote.is_unrepeatable? 
        has_unrepeatable_vote = true
        break
      end
    end
    !has_unrepeatable_vote
  end

  def User.find_with_twitter_screen_name(screen_name)
    User.all.each do |user|
      user.authorizations.each do |auth|
        if auth.screen_name == screen_name
          return user
        end
      end
    end
    return nil
  end
end
