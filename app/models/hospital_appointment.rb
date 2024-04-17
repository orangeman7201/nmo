class HospitalAppointment < ApplicationRecord
  validates :consultation_date, presence: true

  belongs_to :user
end
