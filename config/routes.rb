Rails.application.routes.draw do
  resources :categories
  resources :entries
  resources :results
  resources :matches
  resources :tournaments
  resources :rounds
  resources :teams
  resources :players
  resources :countries
  resources :events
  root 'pages#home'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
