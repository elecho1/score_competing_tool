class ChangeGpAsToUserScores < ActiveRecord::Migration
  def up
    #total
    change_column :user_scores, :gpa, :float, default: 0.0, null: false
    #2A
    #change_column :user_scores, :sem4_gpa, :float, default: 0.0
    #3S
    #change_column :user_scores, :sem5_gpa, :float, default: 0.0
    #3A
    #change_column :user_scores, :sem6_gpa, :float, default: 0.0
  end
  def down
    #total
    change_column :user_scores, :gpa, :float
    #2A
    #change_column :user_scores, :sem4_gpa, :float
    #3S
    #change_column :user_scores, :sem5_gpa, :float
    #3A
    #change_column :user_scores, :sem6_gpa, :float
    
  end
end
