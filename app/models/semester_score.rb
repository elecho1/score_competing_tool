class SemesterScore < ActiveRecord::Base
  #association
  belongs_to :user_score#, touch: true#, counter_cache: :score_count
  
  #validation

end
