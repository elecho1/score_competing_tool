class UserScore < ActiveRecord::Base
  #association
  belongs_to :user
  has_many   :scores, dependent: :delete_all
  has_many   :subjects, through: :scores

  #validation
  validates :user_id, numericality: {only_integer: true}, uniqueness: true, presence: true
  validates :total_score, numericality: {only_integer: true}, presence: true
  validates :GPA, numericality: true
  validates :total_score, numericality: {only_integer: true}, presence: true
  
end
