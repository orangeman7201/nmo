class HospitalAppointmentSerializer < ActiveModel::Serializer
  attributes :id, :consultation_date, :memo
end
