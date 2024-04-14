class AddStrengthToConditions < ActiveRecord::Migration[7.1]
  def change
    add_column :conditions, :strength, :integer, comment: "症状の強さ"
    add_column :conditions, :memo, :text, comment: "メモ"
  end
end
