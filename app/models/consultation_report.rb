class ConsultationReport < ApplicationRecord
  validates :end_date, presence: true

  belongs_to :user
  belongs_to :hospital_appointment
  
  # 日付範囲内の体調情報を取得するスコープ
  def conditions
    return [] unless start_date.present? && end_date.present?
    user.conditions.where(occurred_date: start_date..end_date)
  end

  def set_date
    self.end_date = hospital_appointment.consultation_date

    # 前のhospital_appointmentがあれば、その日付をstart_dateに設定
    previous = hospital_appointment.previous_hospital_appointment
    if previous.present?
      self.start_date = previous.consultation_date
    else
      # 前の予約がない場合は、1ヶ月前をデフォルトとする
      self.start_date = self.end_date - 1.month
    end
  end
end
