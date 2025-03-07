Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token

  root "flights#index"
  get 'search_flights', to: 'flights#search', as: 'search_flights'

  get "up" => "rails/health#show", as: :rails_health_check
end
