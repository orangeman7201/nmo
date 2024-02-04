class Condition < ApplicationRecord
  validates :detail, presence: true
  validates :occurred_date, presence: true
end
