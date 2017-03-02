class Score < ActiveRecord::Base
  #association
  belongs_to :user_score, touch: true, counter_cache: :score_count
  belongs_to :subject
end
