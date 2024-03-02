class Condition < ApplicationRecord
  validates :detail, presence: true
  validates :occurred_date, presence: true

  belongs_to :user
end
