class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :profile   
  has_many :profiles
  has_many :applies
  has_many :jobs, through: :applies
  accepts_nested_attributes_for :profiles
  #validates :profiles, length: { in: 0..1 }
end
