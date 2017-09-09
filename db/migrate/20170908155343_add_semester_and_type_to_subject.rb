class AddSemesterAndTypeToSubject < ActiveRecord::Migration
  def up
    add_column :subjects, :semester, :int, null: false
    add_column :subjects, :subject_type, :string, null: false
  end
  def down
    remove_column :subjects, :semester
    remove_column :subjects, :subject_type
  end
end
