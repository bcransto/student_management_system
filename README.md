# Student Management System

A full-stack web application built with Ruby on Rails (API) and React, featuring JWT authentication and role-based access control.

## 🚀 Features

### Backend (Rails API)
- **JWT Authentication**: Secure token-based authentication system
- **Role-Based Access Control**: Dual user system (regular users and superuser)
- **User Management**: Complete CRUD operations with LASID system
- **RESTful API**: Versioned API endpoints (v1)
- **MySQL Database**: Robust data persistence
- **CORS Configuration**: Secure cross-origin resource sharing

### Frontend (React)
- **Modern React**: Built with React 18 and React Router v6
- **Protected Routes**: Secure navigation with authentication guards
- **Responsive UI**: Tailwind CSS for beautiful, mobile-friendly design
- **User Dashboard**: Interactive dashboard with sidebar navigation
- **Profile Management**: View and edit user profiles
- **Real-time Validation**: Form validation with react-hook-form

## 📋 Prerequisites

- Ruby 3.2.2
- Rails 7.1.5
- Node.js (v14 or higher)
- MySQL 8.0+
- Homebrew (for macOS)

## 🛠️ Installation

### 1. Clone the Repository
```bash
git clone https://github.com/bcransto/student_management_system.git
cd student_management_system
```

### 2. Backend Setup

#### Install Ruby Dependencies
```bash
# Install Ruby version manager (if not installed)
brew install rbenv

# Install Ruby 3.2.2
rbenv install 3.2.2
rbenv local 3.2.2

# Install bundler and gems
gem install bundler
bundle install
```

#### Configure Database
```bash
# Install MySQL (if not installed)
brew install mysql
brew services start mysql

# Create and setup database
rails db:create
rails db:migrate
rails db:seed
```

#### Configure Environment Variables
Create a `.env` file in the root directory:
```env
# Superuser credentials
SUPERUSER_EMAIL=superuser@admin.com
SUPERUSER_PASSWORD=changeme123

# JWT Secret
SECRET_KEY_BASE=your_secret_key_base_here

# Database
DATABASE_HOST=localhost
DATABASE_USERNAME=root
DATABASE_PASSWORD=your_db_password
```

Or use Rails credentials:
```bash
EDITOR="code --wait" rails credentials:edit
```

### 3. Frontend Setup

```bash
cd frontend
npm install
```

## 🚀 Running the Application

### Start Backend Server
```bash
# From root directory
rails server
# Server runs on http://localhost:3000
```

### Start Frontend Development Server
```bash
# From frontend directory
cd frontend
npm start
# Or to run on different port
PORT=3001 npm start
# App runs on http://localhost:3001
```

## 🔑 Authentication

### Test Credentials

**Regular Users:**
- Email: `john@example.com` | Password: `password123` | LASID: `1001`
- Email: `jane@example.com` | Password: `password123` | LASID: `1002`

**Superuser:**
- Email: `superuser@admin.com` | Password: `changeme123`

## 📚 API Documentation

### Authentication Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/v1/auth/login` | User login |
| POST | `/api/v1/auth/superuser/login` | Superuser login |

### User Management Endpoints

| Method | Endpoint | Description | Access |
|--------|----------|-------------|--------|
| GET | `/api/v1/users` | List all users | Superuser |
| GET | `/api/v1/users/:id` | Get user details | User/Superuser |
| POST | `/api/v1/users` | Create user | Superuser |
| PATCH | `/api/v1/users/:id` | Update user | User/Superuser |
| DELETE | `/api/v1/users/:id` | Delete user | Superuser |
| POST | `/api/v1/users/bulk_create` | Bulk create users | Superuser |

### Example API Requests

#### Login as User
```bash
curl -X POST http://localhost:3000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"john@example.com","password":"password123"}'
```

#### Create New User (Superuser Only)
```bash
curl -X POST http://localhost:3000/api/v1/users \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{
    "user": {
      "name": "New User",
      "email": "newuser@example.com",
      "password": "password123",
      "lasid": "1234"
    }
  }'
```

## 🏗️ Project Structure

```
student_management_system/
├── app/                    # Rails application code
│   ├── controllers/        # API controllers
│   ├── models/            # Database models
│   └── ...
├── config/                # Rails configuration
├── db/                    # Database files
├── frontend/              # React application
│   ├── src/
│   │   ├── components/    # React components
│   │   ├── context/       # Context providers
│   │   ├── pages/         # Page components
│   │   └── services/      # API services
│   └── ...
├── lib/                   # Custom libraries
└── test/                  # Test files
```

## 🔒 Security Features

- **Password Encryption**: bcrypt hashing with salt
- **Token Expiration**: JWT tokens expire after 24 hours
- **CORS Protection**: Configured for specific origins
- **SQL Injection Prevention**: ActiveRecord parameterized queries
- **XSS Protection**: React's built-in XSS protection
- **Secure Headers**: Rails security headers enabled

## 🧪 Testing

### Run Backend Tests
```bash
rails test
```

### Run Frontend Tests
```bash
cd frontend
npm test
```

## 📝 Development Tools

### VS Code Setup
The project includes VS Code configuration for optimal Rails development:
- Ruby LSP for intelligent code completion
- Rails-specific extensions
- Debug configuration
- Editor settings

### Recommended VS Code Extensions
- Ruby LSP
- Rails
- Tailwind CSS IntelliSense
- ES7+ React snippets

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📦 Deployment

### Backend Deployment
- Configure production database
- Set production environment variables
- Precompile assets: `rails assets:precompile`
- Run migrations: `rails db:migrate RAILS_ENV=production`

### Frontend Deployment
```bash
cd frontend
npm run build
```
Deploy the `build` directory to your hosting service.

## 🐛 Troubleshooting

### Common Issues

**Ruby version errors:**
```bash
eval "$(rbenv init - zsh)"
rbenv local 3.2.2
```

**Database connection issues:**
```bash
brew services restart mysql
```

**Port already in use:**
```bash
# Find process using port 3000
lsof -i :3000
# Kill the process
kill -9 PID
```

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

## 👥 Authors

- **Brian Cranston** - [bcransto](https://github.com/bcransto)

## 🙏 Acknowledgments

- Built with assistance from Claude AI
- Rails community for excellent documentation
- React community for modern frontend tools

## 📞 Support

For support, please open an issue in the [GitHub repository](https://github.com/bcransto/student_management_system/issues).

---

Built with ❤️ using Rails and React
