class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :profile   
  has_many :applies
  has_many :jobs, through: :applies
  #has_many :feedbacks, through: :applies 
end
