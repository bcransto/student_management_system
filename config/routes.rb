require 'api_constraints'

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # API routes with versioning
  namespace :api, defaults: { format: :json } do
    # Version 1 API (default version)
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      # Authentication routes
      post 'auth/login', to: 'authentication#login'
      post 'auth/superuser/login', to: 'authentication#superuser_login'
      
      # User management routes
      resources :users do
        collection do
          post 'bulk_create'
        end
      end
      
      # Add more v1 routes here as needed
    end
    
    # Future version example (v2)
    # scope module: :v2, constraints: ApiConstraints.new(version: 2) do
    #   # Version 2 routes
    # end
  end
  
  # Alternative: URL-based versioning
  # If you prefer /api/v1/ style URLs instead of header-based versioning:
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      post 'auth/login', to: 'authentication#login'
      post 'auth/superuser/login', to: 'authentication#superuser_login'
      
      resources :users do
        collection do
          post 'bulk_create'
        end
      end
    end
  end
end
