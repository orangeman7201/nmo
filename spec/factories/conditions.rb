FactoryBot.define do
  factory :condition do
    detail { '症状' }
    occurred_date { '2024-01-01' }
    strength { 1 }
    memo { 'メモ' }
  end
end
