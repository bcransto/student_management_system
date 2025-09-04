# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Rails 7.1.5 API-only application implementing a Student Management System with JWT-based authentication and role-based access control. The system has two user types: regular users and a superuser with administrative privileges.

## Essential Commands

### Ruby Environment Setup
```bash
# Always initialize rbenv before running Rails commands
eval "$(rbenv init - zsh)"

# Ruby version: 3.2.2 (managed by rbenv)
# If you see "Required ruby-3.2.2 is not installed" errors, prefix commands with:
eval "$(rbenv init - zsh)" && [your_command]
```

### Development Server
```bash
# Start Rails server
eval "$(rbenv init - zsh)" && rails server

# Start Rails console
eval "$(rbenv init - zsh)" && rails console

# Check server status
ps aux | grep -i puma
```

### Database Operations
```bash
# Create database
eval "$(rbenv init - zsh)" && rails db:create

# Run migrations
eval "$(rbenv init - zsh)" && rails db:migrate

# Seed database with test users
eval "$(rbenv init - zsh)" && rails db:seed

# Reset database (drop, create, migrate, seed)
eval "$(rbenv init - zsh)" && rails db:reset
```

### Testing
```bash
# Run all tests
eval "$(rbenv init - zsh)" && rails test

# Run specific test file
eval "$(rbenv init - zsh)" && rails test test/controllers/api/v1/authentication_controller_test.rb

# Run specific test
eval "$(rbenv init - zsh)" && rails test test/models/user_test.rb -n test_should_validate_lasid_format
```

### Code Generation
```bash
# Generate model
eval "$(rbenv init - zsh)" && rails generate model ModelName field:type

# Generate controller
eval "$(rbenv init - zsh)" && rails generate controller api/v1/ControllerName

# Generate migration
eval "$(rbenv init - zsh)" && rails generate migration AddFieldToTable field:type
```

## Architecture Overview

### Authentication System (JWT-based)

The authentication system is documented in `Auth.MD` and implements:

1. **Dual Login System**
   - Regular users: `/api/v1/auth/login` - authenticated against database
   - Superuser: `/api/v1/auth/superuser/login` - credentials stored in config

2. **User Model** (`app/models/user.rb`)
   - Uses bcrypt for password hashing (`has_secure_password`)
   - Each user has a unique 4-digit LASID (Local Authentication System ID)
   - Email normalization before saving
   - Custom JWT generation method

3. **Authentication Flow**
   - `lib/json_web_token.rb` - JWT encoding/decoding service
   - `app/controllers/concerns/authenticatable.rb` - Shared authentication logic
   - Controllers include Authenticatable concern for authorization
   - Tokens expire after 24 hours

4. **Authorization Levels**
   - Superuser: Full CRUD on all users, can assign/change LASIDs
   - Regular users: Can only view/edit own profile (except LASID)

### API Structure

The API uses versioning with two approaches configured:
- Header-based: `Accept: application/vnd.student-management.v1`
- URL-based: `/api/v1/` (currently active)

Key endpoints:
- `POST /api/v1/auth/login` - User login
- `POST /api/v1/auth/superuser/login` - Superuser login
- `GET/POST/PATCH/DELETE /api/v1/users` - User management
- `POST /api/v1/users/bulk_create` - Bulk user creation (superuser only)

### Rails Configuration

1. **Gems** (key additions to standard Rails):
   - `bcrypt` - Password hashing
   - `jwt` - Token generation
   - `rack-cors` - CORS handling for API access
   - `mysql2` - MySQL adapter

2. **CORS Configuration** (`config/initializers/cors.rb`)
   - Configured for localhost development (ports 3000, 3001)
   - Exposes Authorization header for JWT tokens

3. **Credentials Management**
   - Rails credentials for sensitive data: `rails credentials:edit`
   - Fallback to ENV variables in `config/initializers/app_config.rb`
   - Master key in `config/master.key` (keep secret!)

4. **Database**
   - MySQL 9.4.0 (via Homebrew)
   - Database names: `student_management_system_development`, `student_management_system_test`

### Test Credentials

**Regular Users** (from seeds):
- john@example.com / password123 (LASID: 1001)
- jane@example.com / password123 (LASID: 1002)

**Superuser** (configured in app_config.rb):
- superuser@admin.com / changeme123

## Testing API Endpoints

```bash
# Login as user
curl -X POST http://localhost:3000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"john@example.com","password":"password123"}'

# Use token in subsequent requests
curl -X GET http://localhost:3000/api/v1/users/1 \
  -H "Authorization: Bearer [TOKEN]"
```

## File Structure Notes

- Controllers follow Rails API namespace pattern: `app/controllers/api/v1/`
- Shared authentication logic in concerns: `app/controllers/concerns/authenticatable.rb`
- JWT service class in lib: `lib/json_web_token.rb`
- API versioning constraints: `lib/api_constraints.rb`
- VS Code configuration in `.vscode/` for Rails development

## MySQL Service

```bash
# Start MySQL
brew services start mysql

# Stop MySQL
brew services stop mysql

# Connect to MySQL
mysql -u root
```

## Important Implementation Details

1. The `authorize_request` method in Authenticatable concern runs before all actions except login endpoints
2. Regular User objects don't have `is_superuser` attribute - it's only on the OpenStruct for superuser sessions
3. LASID must be exactly 4 digits and is immutable for regular users
4. Routes are duplicated for both header-based and URL-based versioning (URL-based is simpler for testing)