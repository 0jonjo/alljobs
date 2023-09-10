# frozen_string_literal: true

class Profile < ApplicationRecord
  belongs_to :user
  belongs_to :country
  has_many :comments
  has_many :headhunters, through: :comments
  has_many :headhunters, through: :applies
  validate :legal_age

  validates :name, :birthdate, :educacional_background, :description, :experience, :city, :user_id, :country_id, presence: true
  validates :user_id, uniqueness: true

  def legal_age
    return if birthdate.present? && birthdate < Date.today - 18.years

    errors.add(:birthdate, "must meet the legal age of majority, be 18+.")
  end
end
