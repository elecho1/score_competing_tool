class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.integer :user_score_id, null: false
      t.integer :subject_id, null: false
      t.integer :value
      t.boolean :registered, null: false

      t.timestamps null: false
    end
  end
end
