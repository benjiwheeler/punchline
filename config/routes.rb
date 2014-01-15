Punchline::Application.routes.draw do
#  devise_for :users
  get "memes/search"
  resources :memes
  

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  root 'memes#index'

  match 'paths/', to: 'paths#index', via: :get
  match 'paths/vote', to: 'paths#vote', via: :post
  match 'paths/reset', to: 'paths#reset', via: :post


#  match 'auth/:provider/callback', to: 'sessions#authcallback', via: :get
#  match 'auth/failure', to: 'sessions#authfailure', via: :get
#  match 'signout', to: 'sessions#destroy', as: 'signout', via: :get

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
#devise_scope :user do
#  get 'sign_in', :to => 'devise/sessions#new', :as => :new_user_session
#  get 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
#end
#devise_scope :user do
#   get 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
#end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
