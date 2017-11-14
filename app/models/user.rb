class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:slack],
         #change authentication keys
         :authentication_keys => [:user_key]
         # OmniAuth


  #association
  has_one :user_score, dependent: :destroy
  belongs_to :lab

  #validation
  #validates :user_key, presence: true, uniqueness: true,
  #format: {with: /\w*\z/},
  #length: {minimum: 2, maximum: 50}
  validates :open_user_name, inclusion: {in: [true, false], message: "を選択して下さい"}
  validates :open_score, inclusion: {in: [true, false], message: "を選択して下さい"}
  validates :user_name, length: {maximum: 50, allow_blank: true}
  validates :lab_id, numericality: {only_integer: true}, inclusion: {in: Lab.all.map{|lab| lab.id}}, allow_nil: true

  def email_required?
    false
  end

  def email_changed?
    false
  end

  def self.from_omniauth(auth)
    user = User.where(provider: auth.provider, uid: auth.uid).first
      #user.email = auth.info.email
    unless user
      user = User.create!(
        email:self.dummy_email(auth),
        password: Devise.friendly_token[0,20], user_key: self.dummy_user_key(auth),provider: auth.provider, uid: auth.uid, open_user_name: false, open_score: true
      )
    end
      #user.name = auth.info.name   # assuming the user model has a name
      #user.image = auth.info.image # assuming the user model has an image
      # If you are using confirmable and the provider(s) you use validate emails,
      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation!
    return user
  end

  def self.dummy_user_key(auth)
    "#{auth.uid}_#{auth.provider}"
  end

  def self.dummy_email(auth)
    "#{auth.uid}_#{auth.provider}@example.com"
  end
end
