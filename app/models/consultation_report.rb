class ConsultationReport < ApplicationRecord
  validates :end_date, presence: true

  belongs_to :user
  belongs_to :hospital_appointment
  has_many :conditions, -> { where(occurred_date: [start_date..end_date] ) }
end
