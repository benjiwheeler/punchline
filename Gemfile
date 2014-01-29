#######################################
# canonical items
#######################################
# core setup
source 'https://rubygems.org'
ruby "2.1.0" #ruby "2.0.0"
gem 'rails', '4.0.2'
#######################
# db
gem 'pg'
#######################
# css
gem 'sass-rails', '~> 4.0.0'
#######################
# javascript
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'jquery-ui-rails'
#######################
# api
gem 'jbuilder', '~> 1.2'
gem 'httparty'
#######################
# optimization
gem 'turbolinks'
gem 'uglifier', '>= 1.3.0'
#######################
group :production do
  # deployment
  # heroku
  gem 'rails_12factor'
end
#######################
# inspecting
gem 'awesome_print'
gem 'solid_assert'
#######################
# development
group :development do
  # inspecting
  gem "binding_of_caller"
  gem "better_errors"
  gem "rubocop"
  # debugging
  gem 'pry', group: [:development, :test]
  gem 'pry-rails', group: [:development, :test]
  gem 'pry-byebug', group: [:development, :test] # instead of pry-debugger or pry-nav
  gem 'pry-stack_explorer', group: [:development, :test]
end
#######################
# documentation
group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end
#######################
# admin
#gem 'rails_admin'
#######################
# auth
gem "devise"
gem 'omniauth'
gem 'omniauth-facebook'
# end of canonical
#######################################

#######################################
# this app
#######################################
gem 'omniauth-twitter'
gem 'twitter'
gem 'json'
gem 'font-awesome-rails', '>= 4.0.0'
#######################################

