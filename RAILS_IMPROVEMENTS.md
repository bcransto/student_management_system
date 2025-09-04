# Rails-Aligned Improvements Implementation

This document describes the Rails best practice improvements implemented in the Student Management System API.

## Implemented Improvements

### 1. Rails Concerns for Shared Authentication Logic ✅

**Location**: `app/controllers/concerns/authenticatable.rb`

The `Authenticatable` concern centralizes all authentication logic:
- JWT token decoding and validation
- `authorize_request` before_action
- `current_user` helper method
- `authenticate_superuser!` for admin-only actions
- `authenticate_user_or_superuser!` for user-specific access control

**Usage**:
```ruby
class ApplicationController < ActionController::API
  include Authenticatable
end
```

### 2. CORS Configuration ✅

**Location**: `config/initializers/cors.rb`

Configured CORS middleware to handle cross-origin requests:
- Allows localhost origins for development (ports 3000, 3001)
- Exposes Authorization header for JWT tokens
- Supports all standard HTTP methods
- Ready for production domain configuration

### 3. Rails Credentials System ✅

**Files**:
- `config/credentials.yml.enc` - Encrypted credentials (existing)
- `config/master.key` - Decryption key (keep secret!)
- `config/credentials_example.yml` - Documentation of structure
- `config/initializers/app_config.rb` - Configuration with ENV fallbacks

**To edit credentials**:
```bash
EDITOR="code --wait" rails credentials:edit
# or
EDITOR="vim" rails credentials:edit
```

**Accessing credentials in code**:
```ruby
Rails.application.credentials.dig(:superuser, :email)
Rails.application.credentials.secret_key_base
```

### 4. API Versioning with Rails Routing Constraints ✅

**Files**:
- `lib/api_constraints.rb` - Version constraint class
- `config/routes.rb` - Versioned API routes

**Two versioning approaches implemented**:

1. **Header-based versioning** (using Accept header):
   - Client sends: `Accept: application/vnd.student-management.v1`
   - Default version (v1) works without header

2. **URL-based versioning** (recommended for simplicity):
   - Routes like: `/api/v1/users`
   - Clear and explicit versioning

## Additional Components Created

### JsonWebToken Service
**Location**: `lib/json_web_token.rb`

Handles JWT encoding/decoding with Rails credentials integration.

### Application Configuration
**Location**: `config/initializers/app_config.rb`

Centralizes app configuration with fallbacks to ENV variables.

## Gems Added

- `bcrypt` (~> 3.1.7) - Password hashing
- `jwt` (~> 2.7) - JWT token handling
- `rack-cors` - CORS middleware

## Next Steps

1. **Create the User model**:
   ```bash
   rails generate model User name:string email:string:uniq password_digest:string lasid:string:uniq
   rails db:migrate
   ```

2. **Create controllers**:
   ```bash
   rails generate controller api/v1/authentication
   rails generate controller api/v1/users
   ```

3. **Update Rails credentials** with your actual values:
   ```bash
   EDITOR="code --wait" rails credentials:edit
   ```
   Add:
   ```yaml
   superuser:
     email: your_superuser@email.com
     password: your_secure_password
   ```

4. **Update CORS origins** for production in `config/initializers/cors.rb`

## Testing the API

Once controllers are implemented:

```bash
# Start the server
rails server

# Test health check
curl http://localhost:3000/up

# Test API endpoints (after implementation)
curl -X POST http://localhost:3000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"user@example.com","password":"password123"}'
```

## Benefits of These Improvements

1. **Separation of Concerns**: Authentication logic is DRY and reusable
2. **Security**: Credentials are encrypted, not in plain text ENV files
3. **API Evolution**: Versioning allows backward compatibility
4. **Cross-Origin Support**: Frontend apps can communicate with the API
5. **Rails Best Practices**: Following conventions makes code maintainable

## Notes

- The `lib` directory is auto-loaded in Rails 7.1+ via `config.autoload_lib`
- JWT tokens expire after 24 hours (configurable)
- Superuser credentials should be set via Rails credentials, not ENV
- CORS origins should be restricted in production