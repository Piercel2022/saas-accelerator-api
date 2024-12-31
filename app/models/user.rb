class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :confirmable

  belongs_to :organization
  has_many :subscriptions
  
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
  
  #has_secure_password

end
