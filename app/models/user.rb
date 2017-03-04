class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, 
         #change authentication keys
         :authentication_keys => [:user_key]

  #association
  has_one :user_score, dependent: :delete  

  #validation
  validates :user_key, presence: true, uniqueness: true, 
  format: {with: /\w*\z/}, 
  length: {minimum: 2, maximum: 50}
  validates :open_user_name, inclusion: {in: [true, false], message: "を選択して下さい"}
  validates :open_score, inclusion: {in: [true, false], message: "を選択して下さい"}
  validates :user_name, length: {maximum: 50, allow_blank: true}

end
