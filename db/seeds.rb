# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# テストユーザーの作成
User.find_or_create_by!(email: 'test@example.com') do |user|
  user.password = 'password'
  user.password_confirmation = 'password'
end

puts "テストユーザーが作成されました。"
puts "Email: test@example.com"
puts "Password: password"
