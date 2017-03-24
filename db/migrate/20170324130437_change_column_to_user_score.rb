class ChangeColumnToUserScore < ActiveRecord::Migration
  def change
    change_column :user_scores, :total_score, :float
    change_column :user_scores, :score_count, :float
  end
end
