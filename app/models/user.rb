class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, 
         #change authentication keys
         :authentication_keys => [:user_id]
         

  #validation
  validates :user_id, presence: true, uniqueness: true, 
  format: {with: /\w*\z/}, 
  length: {minimum: 2, maximum: 20}

end
