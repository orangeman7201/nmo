class AddColumnUserIdToCondition < ActiveRecord::Migration[7.1]
  def change
    add_reference :conditions, :user, foreign_key: true
  end
end
