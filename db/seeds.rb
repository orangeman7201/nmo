# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# テスト用ユーザーの作成
test_user = User.find_or_initialize_by(email: 'test@example.com')
if test_user.new_record?
  test_user.password = 'password'
  test_user.password_confirmation = 'password'
  test_user.provider = 'email'
  test_user.uid = 'test@example.com'
  test_user.confirmed_at = Time.current
  test_user.save!
  puts "テストユーザーが作成されました: #{test_user.email}"
else
  # 既存ユーザーが確認済みでない場合は確認済みにする
  unless test_user.confirmed_at
    test_user.confirmed_at = Time.current
    test_user.save!
    puts "テストユーザーが確認済みになりました: #{test_user.email}"
  end
  puts "テストユーザーは既に存在します: #{test_user.email}"
end
