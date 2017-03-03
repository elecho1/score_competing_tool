class Subject < ActiveRecord::Base
  #association
  has_many :scores, dependent: :delete_all
  has_many :user_scores, through: :scores

  #validation
  validates :key, legth: {maximum: true}, presence: true

end
