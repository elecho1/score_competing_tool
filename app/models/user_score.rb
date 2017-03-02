class UserScore < ActiveRecord::Base
  #association
  belongs_to :user
  has_many   :scores, dependent: :delete_all
  has_many   :subjects, through: :scores
  
end
