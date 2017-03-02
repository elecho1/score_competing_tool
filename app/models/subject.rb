class Subject < ActiveRecord::Base
  has_many :scores, dependent: :delete_all
  has_many :user_scores, through: :scores

end
