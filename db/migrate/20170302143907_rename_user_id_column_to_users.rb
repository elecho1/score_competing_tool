class RenameUserIdColumnToUsers < ActiveRecord::Migration
  def change
    rename_column :users, :user_id, :user_key
  end
end
