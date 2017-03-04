class AddIndextoScore < ActiveRecord::Migration
  def change
    add_index :scores, [:user_score_id, :subject_id], unique: true
  end
end
