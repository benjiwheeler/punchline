class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def create
    oauth_params = request.env['omniauth.auth']
    @auth = Authorization.find_from_oauth(oauth_params)
#    binding.pry
    if @auth # found existing auth for that provider
      @auth.update_tokens(oauth_params)
      notice = "Welcome back, #{@auth.user}!"      
#      binding.pry
    elsif current_user # add auth for new provider to current user
      @auth = Authorization.create_from_oauth(oauth_params, current_user)
      notice = "Successfully linked that account!"
#      binding.pry
    else # new provider, user isn't already logged in
      @auth = Authorization.create_from_oauth(oauth_params)
      notice = "Welcome, #{@auth.user}!"
#      binding.pry
    end
    # Log the authorizing user in.
#    binding.pry
    self.current_user= @auth.user
#    binding.pry
    redirect_to root_url, notice: notice
  end


  def failure
    origin = request.env['omniauth.origin']
    destination = origin.blank? ? root_path : origin
    binding.pry
#    super
    redirect_to destination, alert: "Connection failed"
  end

  alias_method :facebook, :create
  alias_method :twitter, :create

  protected

  # This is necessary since Rails 3.0.4
  # See https://github.com/intridea/omniauth/issues/185
  # and http://www.arailsdemo.com/posts/44
  def handle_unverified_request
    true
  end

end
