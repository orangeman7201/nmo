class HospitalAppointment < ApplicationRecord
  validates :consultation_date, presence: true

  belongs_to :user
  has_one :consultation_report

  scope :in_target_month , -> (target_month) do
    month = target_month&.to_date || Time.current
    where(consultation_date: month.to_date.all_month)
  end

  # 一つ前のhospital_appointmentを取得するメソッド
  def previous_hospital_appointment
    user.hospital_appointments.where("consultation_date < ?", consultation_date).order(consultation_date: :desc).first
  end
end
