class CreateUserProgressRecords < ActiveRecord::Migration[7.1]
  def change
    create_table :user_progress_records, id: :uuid do |t|
      t.uuid :user_id, null: false
      t.uuid :lesson_id, null: false
      t.boolean :completed, default: false, null: false
      t.timestamps
    end
    add_index :user_progress_records, [:user_id, :lesson_id], unique: true
  end
end 