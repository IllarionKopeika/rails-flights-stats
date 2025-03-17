Rails.application.routes.draw do
  scope '(:locale)', locale: /ru|en/ do
    # sessions
    resource :session, only: :create
    get 'login', to: 'sessions#new', as: 'login'
    delete 'logout', to: 'sessions#destroy', as: 'logout'

    # change password
    get 'change_password', to: 'passwords#change_password', as: 'change_password'
    patch 'update_password', to: 'passwords#update_password', as: 'update_password'

    # reset password
    resources :password_resets, only: :create
    get 'forgot_password', to: 'password_resets#new', as: 'forgot_password'
    get 'instructions', to: 'password_resets#instructions', as: 'instructions'
    get 'password_resets/edit/:token', to: 'password_resets#edit', as: 'edit_password_reset'
    patch 'password_resets/:token', to: 'password_resets#update', as: 'password_reset'

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
