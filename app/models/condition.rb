class Condition < ApplicationRecord
  validates :detail, presence: true
  validates :occurred_date, presence: true
  validates :strength, presence: true

  belongs_to :user
  belongs_to :consultation_report, optional: true

  scope :in_target_month , -> (target_month) do
    month = target_month&.to_date || Time.current
    where(occurred_date: month.to_date.all_month)
  end
  
  scope :up_to_date, -> (end_date) do
    where('occurred_date <= ?', end_date.to_date)
  end
  
  scope :between_dates, -> (start_date, end_date) do
    where(occurred_date: start_date.to_date..end_date.to_date)
  end
end
