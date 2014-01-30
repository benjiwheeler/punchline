RailsAdmin.config do |config|
  config.current_user_method { current_user } #auto-generated
  # Exclude specific models (keep the others):
   config.excluded_models = ['Authorization', 'Tweet']

  config.authenticate_with do
  #  authenticate_admin!
    true
  end
end
