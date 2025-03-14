Rails.application.routes.draw do
  scope '(:locale)', locale: /ru|en/ do
    # sessions
    resource :session, except: :new
    get 'login', to: 'sessions#new', as: 'login'

    # passwords
    resources :passwords, param: :token
    get 'change_password', to: 'passwords#change_password', as: 'change_password'
    patch 'update_password', to: 'passwords#update_password', as: 'update_password'

    #users
    resources :users, only: :create
    get 'sign_up', to: 'users#new', as: 'sign_up'
    get 'profile', to: 'users#show', as: 'profile'

    # flights
    root 'flights#index'
    get 'search_flights', to: 'flights#search', as: 'search_flights'
  end

  get 'up' => 'rails/health#show', as: :rails_health_check
end
