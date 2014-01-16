class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
#  protected

    def current_user
#      binding.pry
      @current_user ||= User.find_by_id(session[:user_id])
    end

    def signed_in?
      !!current_user
    end

    def current_user=(user)
#      binding.pry
      @current_user = user
      session[:user_id] = user.id
    end

    helper_method :current_user, :signed_in? # why can't include :current_user= ?

    def after_sign_in_path_for(resource_or_scope)
      binding.pry
      if request.env['omniauth.origin']
         request.env['omniauth.origin']
      end
    end

    def user_must_be_logged_in
      redirect_to paths_login_path unless signed_in?
    end

end
