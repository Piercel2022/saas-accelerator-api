Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      devise_for :users, controllers: {
        sessions: 'api/v1/users/sessions',
        registrations: 'api/v1/users/registrations'
      }
      
      resources :organizations do
        resources :users
        resources :subscriptions
      end
      
      resources :billing_plans do
        resources :features
      end
      
      resources :notifications
      resources :activity_logs
      
      post 'auth/login', to: 'auth#login'
      delete 'auth/logout', to: 'auth#logout'
      post 'auth/refresh', to: 'auth#refresh_token'
    end
  end
  
  mount ActionCable.server => '/cable'
end