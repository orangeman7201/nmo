class CreateConditions < ActiveRecord::Migration[7.1]
  def change
    create_table :conditions do |t|
      t.string :detail, null: false
      t.date :occurred_date, null: false

      t.timestamps
    end
  end
end
