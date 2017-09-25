class CreateSemesterScores < ActiveRecord::Migration
  def change
    create_table :semester_scores do |t|
      t.integer :user_score_id, null: false
      t.integer :semester, null: false
      t.float   :total_score, null: false, default: 0.0
      t.float   :gpa, null: false, default: 0.0
      t.float   :score_count, null: false, default: 0.0

      t.timestamps null: false
    end
  end
end
