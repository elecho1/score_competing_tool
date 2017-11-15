class AddColumnToLab < ActiveRecord::Migration
  def up
    add_column :labs, :url, :string, null: true
  end
  def down
    remove_column :labs, :url
  end
end
