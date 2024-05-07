FactoryBot.define do
  factory :consultation_report do
    condition_summary { '気になることのまとめ' }
    consultation_memo { '診断メモ' }
    start_date { '2024-01-01' }
    end_date { '2024-02-01' }
  end
end
