# frozen_string_literal: true

class Profile < ApplicationRecord
  belongs_to :user
  belongs_to :country
  has_many :comments, dependent: :destroy
  has_many :headhunters, through: :comments
  has_many :headhunters, through: :applies
  validate :legal_age

  validates :name, :birthdate, :educacional_background, :description, :experience, :city, :user_id, :country_id,
            presence: true

  scope :find_by_user_id, ->(user_id) { where(user_id:) }

  def legal_age
    return if birthdate.present? && birthdate < Time.zone.today - 18.years

    errors.add(:birthdate, 'must meet the legal age of majority, be 18+.')
  end

  def send_mail_success(action, path)
    SendMailSuccessUserJob.perform_later(id, "#{action} your profile", path)
  end
end
