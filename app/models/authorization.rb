class Authorization < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :provider, :uid
  validates_uniqueness_of :uid, scope: :provider
  
  def self.find_from_oauth(oauth_params)
    find_by_provider_and_uid(oauth_params.provider, oauth_params.uid)
  end
  
  def self.create_from_oauth(oauth_params, user = nil)
#    binding.pry
    # if user is nil, user is not currently logged in; this is auth might be a user returning, or it might be going to be the user's primary auth. 
    user ||= User.find_from_key_or_create(Authorization.user_key(oauth_params))
    # create new Authorization
    newauth = Authorization.new
    # mandatory values
    newauth.user = user
    newauth.name = oauth_params.info.name
    newauth.provider = oauth_params.provider
    newauth.oauth_token = oauth_params.credentials.token
    # facebook
    newauth.uid = oauth_params.uid if oauth_params.uid
    newauth.oauth_expires_at = Time.at(oauth_params.credentials.expires_at) if oauth_params.credentials.expires_at
    newauth.email = oauth_params.info.email if oauth_params.info.email
    # twitter
# deprecated; oauth puts it in nickname    newauth.screen_name = oauth_params.screen_name if oauth_params.screen_name
    newauth.nickname = oauth_params.info.nickname if oauth_params.info.nickname
    newauth.oauth_secret = oauth_params.credentials.secret if oauth_params.credentials.secret
    # optional fields:
    newauth.first_name = oauth_params.info.first_name if oauth_params.info.first_name
    newauth.last_name = oauth_params.info.last_name if oauth_params.info.last_name
    newauth.location = oauth_params.info.location if oauth_params.info.location
    newauth.description = oauth_params.info.description if oauth_params.info.description
    newauth.image = oauth_params.info.image if oauth_params.info.image
    newauth.phone = oauth_params.info.phone if oauth_params.info.phone
    newauth.urls = oauth_params.info.urls.to_json if oauth_params.info.urls
    newauth.raw_info = oauth_params.extra.raw_info.to_json if oauth_params.extra.raw_info

    newauth.save!
    newauth
  end

  def update_tokens(oauth_params)
#    binding.pry
    self.oauth_token = oauth_params.credentials.token
    # facebook
    self.oauth_expires_at = Time.at(oauth_params.credentials.expires_at) if oauth_params.credentials.expires_at
    # twitter
    self.oauth_secret = oauth_params.credentials.secret if oauth_params.credentials.secret
  end

  def self.user_key(oauth_params)
    retval = nil
    retval = oauth_params.info.email if oauth_params.info.email # not sure what the deal is with this
    retval ||= oauth_params.info.nickname if oauth_params.info.nickname # not sure what the deal is with this
    # NOTE: maybe need to fall back on fname last name? 
    retval 
  end
end



