class ConditionSerializer < ActiveModel::Serializer
  attributes :id, :detail, :occurred_date, :strength, :memo
end
