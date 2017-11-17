class AddOpenLabColumnToUser < ActiveRecord::Migration
  def up
    add_column :users, :open_lab, :boolean, null: false, default: false
  end
  def down
    remove_column :users, :open_lab
  end
end
