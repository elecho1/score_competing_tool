class ChangeColumnToUser < ActiveRecord::Migration
  # 変更内容
  # def up
  def change
    change_column :users, :email, :string, null: true, default: "" 
    change_column :users, :encrypted_password, :string, null: true, default: "" 
    remove_index :users, :email
    remove_index :users, :reset_password_token
  end

  # 変更前の状態
  #def down
  #  change_column :users, :email, :encripted_password, null: false, default: "" 
  #  add_index :users, :email,                unique: true
  #  add_index :users, :reset_password_token, unique: true
  #end
end
