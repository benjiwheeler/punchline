RailsAdmin.config do |config|
  config.current_user_method { current_user } 
  # Exclude specific models (keep the others):
   config.excluded_models = ['Authorization', 'Tweet']

  config.authenticate_with do
    unless current_user.is_admin?
      flash[:error] = "You are not an admin"
      redirect_to main_app.root_path
    end
  end
end
