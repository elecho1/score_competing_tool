class Score < ActiveRecord::Base
  #association
  belongs_to :user_score, touch: true#, counter_cache: :score_count
  belongs_to :subject

  #validation
  validates :subject_id, numericality: {only_integer: true}, presence: true
  validates :user_score_id, numericality: {only_integer: true, allow_blank: true}, presence: {on: :update}, uniqueness: {scope: :subject_id}
  validates :registered, inclusion: {in: [true, false]}

  #validates :value, numericality: {only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100}, presence: true, if: :registered

  #temporary
  validates :value, inclusion:{in:[Constants::YUJYOU_VALUE, Constants::YU_VALUE, Constants::RYOU_VALUE, Constants::KA_VALUE, Constants::HUKA_VALUE]}, numericality: {only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100}, presence: true, if: :registered

  validate 

end
