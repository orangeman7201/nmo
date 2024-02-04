class CreateConditions < ActiveRecord::Migration[7.1]
  def change
    create_table :conditions do |t|
      t.string :detail, null: false, comment: '症状の詳細'
      t.date :occurred_date, null: false, comment: '症状があった日'

      t.timestamps
    end
  end
end
