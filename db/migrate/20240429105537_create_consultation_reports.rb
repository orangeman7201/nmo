class CreateConsultationReports < ActiveRecord::Migration[7.1]
  def change
    create_table :consultation_reports do |t|
      t.text :condition_summary, comment: '気になることのまとめ'
      t.text :consultation_memo, comment: '診断メモ'
      t.date :start_date, comment: 'レポートの開始日時'
      t.date :end_date, null: false, comment: 'レポートの終了日時'
      t.references :user, null: false, foreign_key: true, comment: 'ユーザーID'
      t.references :hospital_appointment, null: false, foreign_key: true, comment: '病院予約ID'

      t.timestamps
    end
  end
end
