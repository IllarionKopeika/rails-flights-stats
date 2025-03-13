Rails.application.routes.draw do
  scope '(:locale)', locale: /ru|en/ do
    # sessions
    resource :session, except: :new
    get 'login', to: 'sessions#new', as: 'login'

    # passwords
    resources :passwords, param: :token

    #users
    resources :users, only: :create
    get 'sign_up', to: 'users#new', as: 'sign_up'

    # flights
    root 'flights#index'
    get 'search_flights', to: 'flights#search', as: 'search_flights'
  end

  get 'up' => 'rails/health#show', as: :rails_health_check
end
