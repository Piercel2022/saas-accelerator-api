Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: [:index, :show, :update]
      resources :organizations
      resources :subscriptions
      resources :billing_plans
      
      # Authentication routes
      post 'auth/login', to: 'authentication#login'
      delete 'auth/logout', to: 'authentication#logout'
      post 'auth/refresh', to: 'authentication#refresh'
    end
  end
end