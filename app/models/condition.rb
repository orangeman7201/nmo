class Condition < ApplicationRecord
  validates :detail, presence: true
  validates :occurred_date, presence: true

  belongs_to :user

  scope :in_target_month , -> (target_month) do
    where(occurred_date: target_month.to_date.all_month)
  end
end
