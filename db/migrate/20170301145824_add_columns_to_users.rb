class AddColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :open_user_name, :boolean, null: false
    add_column :users, :open_score, :boolean, null: false
  end
end
