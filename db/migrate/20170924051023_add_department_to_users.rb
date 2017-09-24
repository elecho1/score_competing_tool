class AddDepartmentToUsers < ActiveRecord::Migration
  def up
    add_column :users, :department, :string, null: false, default: "denjo"
  end
  def down
    remove_column :users, :department
  end
end
