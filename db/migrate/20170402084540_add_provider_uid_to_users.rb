class AddProviderUidToUsers < ActiveRecord::Migration
  def change
    add_column :users, :provider, :string
    add_column :users, :uid, :string
    add_column :users, :slack_enabled_flag, :boolean, null:false, default: false 

    add_index :users, [:uid, :provider], unique:true
  end
end
