class CreateLessonRecords < ActiveRecord::Migration[7.1]
  def change
    create_table :lesson_records, id: :uuid do |t|
      t.uuid :course_id, null: false
      t.string :title, null: false
      t.text :content
      t.timestamps
    end
    add_foreign_key :lesson_records, :course_records, column: :course_id
  end
end 