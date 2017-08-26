class RemoveUserKeyIndexFromUser < ActiveRecord::Migration
  def up
    remove_index :users, :user_key
  end
  def down
    add_index :users, :user_key, unique:true
  end
end
