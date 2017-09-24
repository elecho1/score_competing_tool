class AddSemestersColumnsToUserScores < ActiveRecord::Migration
  def up
    #2A
    add_column :user_scores, :sem4_total_score, :float, default: 0, null: false
    add_column :user_scores, :sem4_gpa, :float, default: 0.0, null: false
    add_column :user_scores, :sem4_score_count, :float, default: 0, null: false 
    #3S
    add_column :user_scores, :sem5_total_score, :float, default: 0, null: false
    add_column :user_scores, :sem5_gpa, :float, default: 0.0, null: false
    add_column :user_scores, :sem5_score_count, :float, default: 0, null: false 
    #3A
    add_column :user_scores, :sem6_total_score, :float, default: 0, null: false
    add_column :user_scores, :sem6_gpa, :float, default: 0.0, null: false
    add_column :user_scores, :sem6_score_count, :float, default: 0, null: false 
  end
  def down
    #2A
    remove_column :user_scores, :sem4_total_score
    remove_column :user_scores, :sem4_gpa
    remove_column :user_scores, :sem4_score_count
    #3S
    remove_column :user_scores, :sem5_total_score
    remove_column :user_scores, :sem5_gpa
    remove_column :user_scores, :sem5_score_count
    #3A
    remove_column :user_scores, :sem6_total_score
    remove_column :user_scores, :sem6_gpa
    remove_column :user_scores, :sem6_score_count
  end
end
