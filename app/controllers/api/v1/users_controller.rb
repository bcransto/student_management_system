class Api::V1::UsersController < ApplicationController
  before_action :authenticate_superuser!, only: [:index, :create, :bulk_create, :destroy]
  before_action :set_user, only: [:show, :update, :destroy]
  before_action :authorize_user_access!, only: [:show, :update]
  
  # GET /api/v1/users
  # Superuser only
  def index
    users = User.all
    render json: users, status: :ok
  end
  
  # GET /api/v1/users/:id
  # User can view own profile, superuser can view any
  def show
    render json: @user, status: :ok
  end
  
  # POST /api/v1/users
  # Superuser only
  def create
    user = User.new(user_params)
    
    if user.save
      render json: {
        message: 'User created successfully',
        user: user
      }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  # POST /api/v1/users/bulk_create
  # Superuser only
  def bulk_create
    users_data = params[:users]
    
    if users_data.blank? || !users_data.is_a?(Array)
      return render json: { error: 'Users array is required' }, status: :bad_request
    end
    
    created_users = []
    failed_users = []
    
    users_data.each_with_index do |user_data, index|
      user = User.new(user_data.permit(:name, :email, :password, :lasid))
      
      if user.save
        created_users << user
      else
        failed_users << {
          index: index,
          data: user_data,
          errors: user.errors.full_messages
        }
      end
    end
    
    render json: {
      created: created_users,
      errors: failed_users,
      summary: "Created #{created_users.count} users, #{failed_users.count} failed"
    }, status: :ok
  end
  
  # PATCH/PUT /api/v1/users/:id
  # User can update own profile (except LASID), superuser can update any
  def update
    # Regular users cannot change their LASID
    is_superuser = current_user.respond_to?(:is_superuser) && current_user.is_superuser
    update_params = if is_superuser
      user_params
    else
      user_params.except(:lasid)
    end
    
    if @user.update(update_params)
      render json: {
        message: 'User updated successfully',
        user: @user
      }, status: :ok
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  # DELETE /api/v1/users/:id
  # Superuser only
  def destroy
    @user.destroy
    render json: { message: 'User deleted successfully' }, status: :ok
  end
  
  private
  
  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'User not found' }, status: :not_found
  end
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :lasid)
  end
  
  def authorize_user_access!
    authenticate_user_or_superuser!(params[:id])
  end
end