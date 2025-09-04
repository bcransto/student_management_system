# Authentication Controller and User Model Documentation

## Overview

This document describes the authentication system and user model for a Rails API-only application with superuser-controlled user management. The system uses JWT (JSON Web Tokens) for stateless authentication and MySQL as the database.

## Architecture Summary

- **Authentication Method**: JWT-based token authentication
- **Password Security**: bcrypt hashing via Rails' `has_secure_password`
- **User Creation**: Superuser-only (no self-registration)
- **Database**: MySQL
- **API Format**: JSON responses

## User Model

### Purpose
The User model represents authenticated users in the system. Each user has a unique email address and a unique 4-digit LASID (Local Authentication System ID) assigned by the superuser.

### Schema

| Field | Type | Constraints | Description |
|-------|------|------------|-------------|
| `id` | integer | Primary key, auto-increment | Unique identifier |
| `name` | string | Required, max 50 chars | User's display name |
| `email` | string | Required, unique, valid email format | Login credential |
| `password_digest` | string | Required | Bcrypt-hashed password |
| `lasid` | string(4) | Required, unique, exactly 4 digits | Local Authentication System ID |
| `created_at` | datetime | Auto-generated | Record creation timestamp |
| `updated_at` | datetime | Auto-generated | Last modification timestamp |

### Key Features

#### Validations
- **Email**: Must be unique (case-insensitive), present, and valid format
- **Name**: Required, maximum 50 characters
- **Password**: Minimum 6 characters (validated on creation or when changed)
- **LASID**: Must be exactly 4 digits, unique across all users

#### Security Features
- Passwords are never stored in plain text
- Email addresses are normalized (lowercased and trimmed) before saving
- Password digest is excluded from JSON responses
- JWT token generation for stateless authentication

#### Methods
- `generate_jwt`: Creates a JWT token for the user
- `self.find_by_credentials(email, password)`: Class method for authentication
- Custom `as_json` to exclude sensitive fields

### Database Indexes
- Unique index on `email`
- Unique index on `lasid`
- Primary key index on `id`

## Authentication Controller

### Purpose
Handles user authentication and session management through JWT tokens. Provides login functionality for regular users and a separate endpoint for superuser authentication.

### Endpoints

#### 1. User Login
**POST** `/auth/login`

Authenticates regular users with email and password credentials.

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

**Success Response (200 OK):**
```json
{
  "token": "eyJhbGciOiJIUzI1NiJ9...",
  "exp": "09-05-2025 14:30",
  "user": {
    "id": 1,
    "name": "John Doe",
    "email": "john@example.com",
    "lasid": "1234"
  }
}
```

**Error Response (401 Unauthorized):**
```json
{
  "error": "Invalid email or password"
}
```

#### 2. Superuser Login
**POST** `/auth/superuser/login`

Special authentication endpoint for the superuser account, validated against environment variables.

**Request Body:**
```json
{
  "email": "superuser@admin.com",
  "password": "super_secure_password"
}
```

**Success Response (200 OK):**
```json
{
  "token": "eyJhbGciOiJIUzI1NiJ9...",
  "user": {
    "email": "superuser@admin.com",
    "is_superuser": true
  }
}
```

### Authentication Flow

1. **Login Request**: User submits email and password
2. **Credential Verification**: System finds user by email and verifies password using bcrypt
3. **Token Generation**: On successful authentication, generate JWT token with 24-hour expiration
4. **Token Usage**: Client includes token in Authorization header for subsequent requests
5. **Request Authorization**: Each protected endpoint validates the token before processing

### Token Structure

JWT tokens contain:
- `user_id`: The user's database ID (for regular users)
- `is_superuser`: Boolean flag for superuser tokens
- `exp`: Token expiration timestamp (24 hours from creation)

## Users Controller

### Purpose
Manages user CRUD operations with role-based access control. Superusers have full control while regular users can only view and update their own profiles.

### Endpoints

#### User Management (Superuser Required)

**GET** `/api/v1/users` - List all users  
**POST** `/api/v1/users` - Create new user  
**POST** `/api/v1/users/bulk_create` - Create multiple users  
**DELETE** `/api/v1/users/:id` - Delete user  

#### User Profile (User or Superuser)

**GET** `/api/v1/users/:id` - View user profile (own profile or any if superuser)  
**PATCH** `/api/v1/users/:id` - Update user profile  

### Create User Example (Superuser Only)

**Request:**
```json
{
  "user": {
    "name": "Jane Smith",
    "email": "jane@example.com",
    "password": "password123",
    "lasid": "5678"
  }
}
```

**Response:**
```json
{
  "message": "User created successfully",
  "user": {
    "id": 2,
    "name": "Jane Smith",
    "email": "jane@example.com",
    "lasid": "5678"
  }
}
```

### Bulk Create Example (Superuser Only)

**Request:**
```json
{
  "users": [
    {
      "name": "User One",
      "email": "user1@example.com",
      "password": "pass123",
      "lasid": "1111"
    },
    {
      "name": "User Two",
      "email": "user2@example.com",
      "password": "pass123",
      "lasid": "2222"
    }
  ]
}
```

**Response:**
```json
{
  "created": [/* array of created users */],
  "errors": [/* array of errors if any */],
  "summary": "Created 2 users, 0 failed"
}
```

## Security Considerations

### Authorization Middleware
All endpoints except login are protected by `authorize_request` before_action that:
1. Extracts token from Authorization header
2. Decodes and validates JWT token
3. Sets `@current_user` for the request
4. Returns 401 Unauthorized for invalid/expired tokens

### Permission Levels

| Action | Regular User | Superuser |
|--------|-------------|-----------|
| Login | ✅ Own account | ✅ Superuser account |
| View Profile | ✅ Own only | ✅ Any user |
| Update Profile | ✅ Own only (except LASID) | ✅ Any user (all fields) |
| Create User | ❌ | ✅ |
| Delete User | ❌ | ✅ |
| Bulk Create | ❌ | ✅ |
| Change LASID | ❌ | ✅ |

### Password Security
- Passwords are hashed using bcrypt (cost factor 10-12)
- Minimum length enforced (6 characters)
- Password digest never exposed in API responses
- Password confirmation required for user creation

### Token Security
- Tokens expire after 24 hours
- Secret key stored in environment variables
- Tokens are stateless (no server-side session storage)
- Each request must include valid token

## Environment Configuration

Required environment variables:
```bash
# Superuser credentials
SUPERUSER_EMAIL=superuser@admin.com
SUPERUSER_PASSWORD=super_secure_password_here

# JWT Secret
SECRET_KEY_BASE=your_secret_key_base_here

# Database
DATABASE_HOST=localhost
DATABASE_USERNAME=root
DATABASE_PASSWORD=your_db_password
```

## Error Handling

The system returns appropriate HTTP status codes:

- **200 OK**: Successful request
- **201 Created**: Resource created successfully
- **401 Unauthorized**: Invalid or missing authentication
- **403 Forbidden**: Authenticated but lacking permissions
- **404 Not Found**: Resource not found
- **422 Unprocessable Entity**: Validation errors

### Validation Error Response Example
```json
{
  "errors": [
    "Email has already been taken",
    "LASID must be exactly 4 digits"
  ]
}
```

## Implementation Checklist

- [ ] Install required gems (bcrypt, jwt, rack-cors, mysql2)
- [ ] Create User model with migrations
- [ ] Implement JWT token handling in lib/json_web_token.rb
- [ ] Create Authentication controller
- [ ] Create Users controller with superuser checks
- [ ] Configure routes
- [ ] Set up CORS for frontend communication
- [ ] Configure environment variables
- [ ] Add database indexes for performance
- [ ] Write seeds for initial testing
- [ ] Test all endpoints with authorization scenarios

## Testing Recommendations

1. **Unit Tests**: Model validations, JWT encoding/decoding
2. **Integration Tests**: Authentication flow, authorization checks
3. **Security Tests**: Token expiration, invalid tokens, SQL injection prevention
4. **Performance Tests**: Database query optimization with indexes

## Future Enhancements

Potential improvements to consider:
- Password reset functionality
- Token refresh mechanism
- Rate limiting for login attempts
- Activity logging and audit trail
- Two-factor authentication
- Email verification
- Account lockout after failed attempts
- Role-based permissions (if needed later)
- API versioning strategy