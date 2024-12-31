Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      devise_for :users, controllers: {
        sessions: 'api/v1/users/sessions',
        registrations: 'api/v1/users/registrations',
        passwords: 'api/v1/users/passwords'
      }
      
      # Organization management
      resources :organizations do
        resources :users
        resources :teams
        resources :roles
        resources :subscriptions
        resources :usage_metrics
        
        # Custom organization endpoints
        get 'dashboard', on: :member
        get 'audit_logs', on: :member
        post 'invite_members', on: :member
      end
      
      # Billing and subscriptions
      resources :billing_plans do
        resources :features
        get 'compare', on: :collection
      end
      
      resources :subscriptions do
        resources :invoices
        resources :payment_methods
        post 'cancel', on: :member
        post 'reactivate', on: :member
        get 'preview_change', on: :member
      end
      
      # User-specific resources
      resources :notifications do
        post 'mark_all_read', on: :collection
        post 'mark_read', on: :member
      end
      
      resources :activity_logs
      resources :user_preferences
      
      # Authentication endpoints
      post 'auth/login', to: 'auth#login'
      delete 'auth/logout', to: 'auth#logout'
      post 'auth/refresh', to: 'auth#refresh_token'
      post 'auth/forgot_password', to: 'auth#forgot_password'
      
      # API documentation
      get 'docs', to: 'docs#index'
      
      # Health check endpoint
      get 'health', to: 'health#show'
    end
  end
  
  mount ActionCable.server => '/cable'
  mount Sidekiq::Web => '/sidekiq'
end