class HospitalAppointment < ApplicationRecord
  validates :consultation_date, presence: true

  belongs_to :user

  scope :in_target_month , -> (target_month) do
    month = target_month&.to_date || Time.current
    where(consultation_date: month.to_date.all_month)
  end
end
