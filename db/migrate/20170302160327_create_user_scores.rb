class CreateUserScores < ActiveRecord::Migration
  def change
    create_table :user_scores do |t|
      t.integer :user_id, null: false
      t.integer :total_score, defualt: 0, null: false
      t.float   :gpa
      t.integer :score_count, default: 0, null: false

      t.timestamps null: false
    end
  end
end
