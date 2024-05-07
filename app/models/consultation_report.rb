class ConsultationReport < ApplicationRecord
  validates :end_date, presence: true

  belongs_to :user
  belongs_to :hospital_appointment
  has_many :conditions, -> { where(occurred_date: [start_date..end_date] ) }

  def set_date
    self.end_date = hospital_appointment.consultation_date

    # 前のhospital_appointmentがあれば、その日付をstart_dateに設定
    if user.have_hospital_appointments?
      self.start_date = hospital_appointment.previous_hospital_appointment.consultation_date
    end
  end
end
