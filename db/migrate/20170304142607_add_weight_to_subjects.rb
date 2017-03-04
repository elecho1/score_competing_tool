class AddWeightToSubjects < ActiveRecord::Migration
  def change
    add_column :subjects, :weight, :float, null: false
  end
end
