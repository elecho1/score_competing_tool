class AddUsernameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :user_id, :string, null: false
    add_index :users, :user_id, unique: true
  end
end
