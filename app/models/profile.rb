# frozen_string_literal: true

class Profile < ApplicationRecord
  belongs_to :user
  belongs_to :country
  has_many :applies, through: :user
  has_many :comments, through: :applies
  has_many :commenting_headhunters, through: :comments, source: :author, source_type: 'Headhunter'
  has_many :stars, through: :applies
  has_many :starring_headhunters, through: :stars, source: :headhunter
  validate :legal_age

  validates :name, :birthdate, :educational_background, :description, :experience, :city, presence: true

  scope :find_by_user_id, ->(user_id) { where(user_id:) }

  def legal_age
    return if birthdate.present? && birthdate < Time.zone.today - 18.years

    errors.add(:birthdate, 'must meet the legal age of majority, be 18+.')
  end

  def send_mail_success(action, path)
    SendMailSuccessUserJob.perform_later(id, "#{action} your profile", path)
  end
end
