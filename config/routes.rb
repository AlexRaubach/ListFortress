Rails.application.routes.draw do
  resources :tournaments

  get 'login', to: redirect('/auth/google_oauth2'), as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'home', to: 'home#show'

  root to: 'home#show'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
