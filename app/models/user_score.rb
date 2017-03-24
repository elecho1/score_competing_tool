class UserScore < ActiveRecord::Base
  #association
  belongs_to :user
  has_many   :scores, dependent: :delete_all
  accepts_nested_attributes_for :scores
  has_many   :subjects, through: :scores

  #validation
  validates :user_id, numericality: {only_integer: true}, uniqueness: true, presence: true
  validates :total_score, numericality: true, presence: true
  validates :gpa, numericality: true
  validates :score_count, numericality: true, presence: true
  
end
