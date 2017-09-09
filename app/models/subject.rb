class Subject < ActiveRecord::Base
  #association
  has_many :scores, dependent: :delete_all
  has_many :user_scores, through: :scores

  #validation
  validates :key, length: {maximum: 100}, presence: true
  validates :weight, numericality: true
  validates :type, numericality: true
end
