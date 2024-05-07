class ConsultationReportSerializer < ActiveModel::Serializer
  attributes :id, :condition_summary, :consultation_memo, :start_date, :end_date
end
