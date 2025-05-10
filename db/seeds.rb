# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# テスト用ユーザーの作成（開発環境のみ）
if Rails.env.development? || Rails.env.test?
  # 環境変数からパスワードを取得、設定されていない場合はセキュアなランダムパスワードを生成
  test_password = ENV.fetch('TEST_USER_PASSWORD') { SecureRandom.alphanumeric(12) }
  
  test_user = User.find_or_initialize_by(email: 'test@example.com')
  if test_user.new_record?
    test_user.password = test_password
    test_user.password_confirmation = test_password
    test_user.provider = 'email'
    test_user.uid = 'test@example.com'
    test_user.confirmed_at = Time.current
    test_user.save!
    puts "テストユーザーが作成されました: #{test_user.email}"
    puts "パスワード: #{test_password}" if Rails.env.development?
  else
    # 既存ユーザーが確認済みでない場合は確認済みにする
    unless test_user.confirmed_at
      test_user.confirmed_at = Time.current
      test_user.save!
      puts "テストユーザーが確認済みになりました: #{test_user.email}"
    end
    puts "テストユーザーは既に存在します: #{test_user.email}"
  end
end
