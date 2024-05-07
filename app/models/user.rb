# frozen_string_literal: true

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  has_many :conditions
  has_many :hospital_appointments
  has_many :consultation_reports

  # hospital_appointmentが2つ以上あればtrueを返すメソッド
  def have_hospital_appointments?
    hospital_appointments.count >= 2
  end
end
