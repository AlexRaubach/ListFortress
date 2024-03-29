Rails.application.routes.draw do
  # redirect www traffic to regular domain
  match "(*any)",
    to: redirect(subdomain: ""),
    via: :all,
    constraints: { subdomain: "www" }

  resources :league_signups
  get 'league_participant/:id', to: 'league_participant#show', as: 'league_participant'
  get 'tournaments/feed', to: 'tournaments#feed', as: 'tournament_feed'
  resources :seasons, only: [:index, :show], param: :season_number
  resources :divisions, only: [:show]
  resources :season_seven_surveys
  resources :participants
  resources :tournaments
  resources :rounds
  resources :matches

  # get 'login', to: redirect('/auth/slack'), as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  get 'auth/failure', to: 'sessions#failure'
  match '/auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
  get 'auth/:provider/callback', to: 'sessions#create'
  match '/logout', to: 'sessions#destroy', via: [:get, :post]

  # get 'home', to: 'home#show'
  get 'about', to: 'home#about'

  get 'league/interdivisional', to: 'league#interdivisional', as: 'interdivisional'
  post 'league/interdivisional', to: 'league#create_interdivisional'
  get 'league', to: 'league#index', as: 'league'
  get 'me', to: 'me#home'
  post 'me', to: 'me#update'

  root to: 'tournaments#index'

  # api
  namespace :api do
    namespace :v1 do
      resources :tournaments, only: [:index, :show] do
        resources :participants, only: [:show]
        resources :rounds, only: [:show] do
          resources :matches, only: [:show]
        end
      end
      
      resources :seasons, only: [:index, :show]
      
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
