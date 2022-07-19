# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/', to: 'welcome#index'
  get '/register', to: 'users#new'
  get '/login', to: 'users#login_form'
  post '/login', to: 'users#login_user'

  get '/discover', to: 'users#discover'

  get '/movies', to: 'user_movies#index'
  get '/movies/:movie_id', to: 'user_movies#show'

  get '/dashboard', to: 'users#show'

  resources :users, only: :create

  resources :viewing_parties, only: %i[create]

  get '/movies/:movie_id/viewing_party/new', to: 'viewing_parties#new'
end
