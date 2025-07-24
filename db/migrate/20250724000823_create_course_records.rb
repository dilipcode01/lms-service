class CreateCourseRecords < ActiveRecord::Migration[7.1]
  def change
    create_table :course_records, id: :uuid do |t|
      t.string :title, null: false
      t.text :description
      t.timestamps
    end
  end
end 