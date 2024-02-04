ActiveRecord::Schema[7.1].define(version: 2024_02_04_085348) do
  enable_extension "plpgsql"

  create_table "conditions", force: :cascade do |t|
    t.string "detail", null: false
    t.date "occurred_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
