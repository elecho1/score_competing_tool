class AddLabToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :lab
  end
end
