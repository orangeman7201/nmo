class CreateHospitalAppointments < ActiveRecord::Migration[7.1]
  def change
    create_table :hospital_appointments do |t|
      t.date :consultation_date, null: false, comment: '診察日'
      t.text :memo, comment: 'メモ'
      t.references :user, null: false, foreign_key: true, comment: 'ユーザーID'

      t.timestamps
    end
  end
end
