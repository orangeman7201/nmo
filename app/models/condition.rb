class Condition < ApplicationRecord
  validates :detail, presence: true
  validates :occurred_date, presence: true
  validates :strength, presence: true

  belongs_to :user

  scope :in_target_month , -> (target_month) do
    month = target_month&.to_date || Time.current
    where(occurred_date: month.to_date.all_month)
  end
end
