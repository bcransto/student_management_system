# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin Ajax requests.

# Read more: https://github.com/cyu/rack-cors

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # In development, allow localhost origins
    origins 'localhost:3000', 'localhost:3001', '127.0.0.1:3000', '127.0.0.1:3001'
    
    # In production, you would specify your actual frontend domain:
    # origins 'https://your-frontend-app.com'
    
    # For development/testing, you can use:
    # origins '*'  # Allow all origins (not recommended for production)

    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      expose: ['Authorization'],
      max_age: 600
  end
end
