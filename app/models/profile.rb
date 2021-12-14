class Profile < ApplicationRecord
  belongs_to :user
  accepts_nested_attributes_for :user

  has_many :comments
  has_many :headhunters, through: :comments
end
