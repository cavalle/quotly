Quotly::Application.routes.draw do

  resources :users
  resources :quotes
  resources :sources
  resources :authors

  get '/login'  => 'sessions#new',     :as => :login
  get '/logout' => 'sessions#destroy', :as => :logout
  get '/auth/twitter/callback' => 'sessions#create'
  get '/:nickname' => 'users#show'
  root :to => "home#show"
end
