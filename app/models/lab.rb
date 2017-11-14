class Lab < ActiveRecord::Base
  # association
  has_many :users

  #validation
  validates :lab_id, numericality: {only_integer: true}
end
