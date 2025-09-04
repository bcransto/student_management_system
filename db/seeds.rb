# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "Seeding database..."

# Create test users
users = [
  {
    name: "John Doe",
    email: "john@example.com",
    password: "password123",
    lasid: "1001"
  },
  {
    name: "Jane Smith",
    email: "jane@example.com",
    password: "password123",
    lasid: "1002"
  },
  {
    name: "Bob Johnson",
    email: "bob@example.com",
    password: "password123",
    lasid: "1003"
  },
  {
    name: "Alice Williams",
    email: "alice@example.com",
    password: "password123",
    lasid: "1004"
  },
  {
    name: "Charlie Brown",
    email: "charlie@example.com",
    password: "password123",
    lasid: "1005"
  }
]

users.each do |user_data|
  user = User.find_or_initialize_by(email: user_data[:email])
  if user.new_record?
    user.assign_attributes(user_data)
    if user.save
      puts "Created user: #{user.name} (#{user.email})"
    else
      puts "Failed to create user: #{user.errors.full_messages.join(', ')}"
    end
  else
    puts "User already exists: #{user.email}"
  end
end

puts "\nSeeding complete!"
puts "Total users: #{User.count}"
puts "\n" + "="*50
puts "Test Credentials:"
puts "="*50
puts "\nRegular Users:"
User.all.each do |user|
  puts "  Email: #{user.email}, Password: password123, LASID: #{user.lasid}"
end
puts "\nSuperuser:"
puts "  Email: #{Rails.application.config.superuser_email}"
puts "  Password: #{Rails.application.config.superuser_password}"
puts "\n" + "="*50
