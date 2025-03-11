Rails.application.routes.draw do
  scope "(:locale)", locale: /ru|en/ do
    resource :session
    resources :passwords, param: :token
    root "flights#index"
    get 'search_flights', to: 'flights#search', as: 'search_flights'
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
