class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable,
   :confirmable,  :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  belongs_to :organization
  has_many :subscriptions
  has_many :team_memberships
  has_many :teams, through: :team_memberships
  has_many :notifications
  has_many :activity_logs
  has_one :user_preference
  
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
  
  #has_secure_password

end
