Rails.application.routes.draw do
  get 'league_participant/:id', to: 'league_participant#show', as: 'league_participant'
  resources :seasons, only: [:show, :index]
  resources :divisions, only: [:show]
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
  get 'league/interdivisional', to: 'league#interdivisional'
  post 'league/interdivisional', to: 'league#create_interdivisional'
  get 'league', to: 'league#index'

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
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
