# frozen_string_literal: true

class Profile < ApplicationRecord
  belongs_to :user
  belongs_to :country
  has_many :comments
  has_many :headhunters, through: :comments
  has_many :headhunters, through: :applies

  validates :name, :birthdate, :educacional_background, :experience, :user_id, :country_id, presence: true
  validates :user_id, uniqueness: true
end
