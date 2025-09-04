# app/controllers/concerns/authenticatable.rb
module Authenticatable
  extend ActiveSupport::Concern

  included do
    before_action :authorize_request
  end

  private

  def authorize_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    
    begin
      decoded = JsonWebToken.decode(header)
      
      if decoded[:is_superuser]
        @current_user = OpenStruct.new(
          email: Rails.application.credentials.dig(:superuser, :email),
          is_superuser: true
        )
      else
        @current_user = User.find(decoded[:user_id])
      end
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: 'User not found' }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: 'Invalid token' }, status: :unauthorized
    rescue JWT::ExpiredSignature => e
      render json: { errors: 'Token has expired' }, status: :unauthorized
    rescue StandardError => e
      render json: { errors: 'Unauthorized' }, status: :unauthorized
    end
  end

  def current_user
    @current_user
  end

  def authenticate_superuser!
    is_superuser = current_user.respond_to?(:is_superuser) && current_user.is_superuser
    unless is_superuser
      render json: { error: 'Forbidden: Superuser access required' }, status: :forbidden
    end
  end

  def authenticate_user_or_superuser!(user_id)
    is_superuser = current_user.respond_to?(:is_superuser) && current_user.is_superuser
    unless is_superuser || current_user&.id == user_id.to_i
      render json: { error: 'Forbidden: You can only access your own data' }, status: :forbidden
    end
  end
end