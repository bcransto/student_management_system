class Api::V1::AuthenticationController < ApplicationController
  skip_before_action :authorize_request
  
  # POST /api/v1/auth/login
  def login
    user = User.find_by_credentials(params[:email], params[:password])
    
    if user
      token = user.generate_jwt
      time = Time.now + Rails.application.config.jwt_expiration_hours.hours
      
      render json: {
        token: token,
        exp: time.strftime("%m-%d-%Y %H:%M"),
        user: user
      }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end
  
  # POST /api/v1/auth/superuser/login
  def superuser_login
    email = params[:email]
    password = params[:password]
    
    # Check against configured superuser credentials
    if email == Rails.application.config.superuser_email && 
       password == Rails.application.config.superuser_password
      
      token = JsonWebToken.encode({ is_superuser: true })
      
      render json: {
        token: token,
        user: {
          email: email,
          is_superuser: true
        }
      }, status: :ok
    else
      render json: { error: 'Invalid superuser credentials' }, status: :unauthorized
    end
  end
end
