Rails.application.routes.draw do
  resources :season_seven_surveys
  resources :participants
  resources :tournaments
  resources :rounds
  resources :matches

  get 'login', to: redirect('/auth/google_oauth2'), as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'home', to: 'home#show'
  match '/auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
  match '/logout', to: 'sessions#destroy', via: [:get, :post]
  
  get 'league', to: 'league#index'

  root to: 'tournaments#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
