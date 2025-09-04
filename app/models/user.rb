class User < ApplicationRecord
  # Use bcrypt for password hashing
  has_secure_password
  
  # Callbacks
  before_save :normalize_email
  
  # Validations
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, 
            presence: true, 
            uniqueness: { case_sensitive: false },
            format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }, if: :password_required?
  validates :lasid, 
            presence: true, 
            uniqueness: true,
            length: { is: 4 },
            format: { with: /\A\d{4}\z/, message: "must be exactly 4 digits" }
  
  # Generate JWT token for authentication
  def generate_jwt
    JsonWebToken.encode(user_id: id)
  end
  
  # Class method to find user by credentials
  def self.find_by_credentials(email, password)
    user = find_by(email: email.downcase.strip)
    user if user&.authenticate(password)
  end
  
  # Override as_json to exclude sensitive fields
  def as_json(options = {})
    super(options.merge(except: [:password_digest, :created_at, :updated_at]))
  end
  
  private
  
  def normalize_email
    self.email = email.downcase.strip if email.present?
  end
  
  def password_required?
    password_digest.nil? || password.present?
  end
end
