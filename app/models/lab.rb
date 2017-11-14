class Lab < ActiveRecord::Base
  # association
  has_many :users

  #validation
  validates :lab_id, numericality: {only_integer: true}, inclusion: {in: Lab.select(:id)}, allow_nil: true
end
