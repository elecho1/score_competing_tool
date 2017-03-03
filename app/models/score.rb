class Score < ActiveRecord::Base
  #association
  belongs_to :user_score, touch: true, counter_cache: :score_count
  belongs_to :subject

  #validation
  validates :user_score_id, numericality: {only_integer: true}, uniqueness: true, presence: true
  validates :subject_id, numericality: {only_integer: true}, uniqueness: true, presence: true
  validates :value, numericality: {only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100}, presence: true
end
