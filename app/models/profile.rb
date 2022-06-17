class Profile < ApplicationRecord
  belongs_to :user
  has_many :comments
  has_many :headhunters, through: :comments
  has_many :stars
  has_many :headhunters, through: :stars
  
  validates :name, :birthdate, :educacional_background, :experience, :user_id, presence: true
  validates :user_id, uniqueness: true
end
