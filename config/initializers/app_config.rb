# config/initializers/app_config.rb
# Application configuration using Rails credentials

# This initializer demonstrates how to access Rails credentials
# To edit credentials, run: rails credentials:edit

# Example of accessing credentials with fallback to ENV variables:
# Rails.application.config.superuser_email = Rails.application.credentials.dig(:superuser, :email) || ENV['SUPERUSER_EMAIL']
# Rails.application.config.superuser_password = Rails.application.credentials.dig(:superuser, :password) || ENV['SUPERUSER_PASSWORD']

# For now, we'll use ENV variables as fallback until credentials are properly set up
Rails.application.config.superuser_email = ENV['SUPERUSER_EMAIL'] || 'superuser@admin.com'
Rails.application.config.superuser_password = ENV['SUPERUSER_PASSWORD'] || 'changeme123'

# JWT configuration
Rails.application.config.jwt_expiration_hours = 24