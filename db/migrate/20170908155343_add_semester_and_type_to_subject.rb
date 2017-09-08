class AddSemesterAndTypeToSubject < ActiveRecord::Migration
  def up
    add_column :subjects, :semester, :int, null: false
    add_column :subjects, :type, :string, null: false
  end
  def down
    remove_column :subjects, :semester
    remove_column :subjects, :type
  end
end
