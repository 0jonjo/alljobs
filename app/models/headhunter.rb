# frozen_string_literal: true

class Headhunter < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :comments, as: :author, dependent: :destroy
  has_many :stars, dependent: :destroy
  has_many :applies, through: :stars
  has_many :users, through: :applies
  has_many :profiles, through: :users

  after_create_commit :send_welcome_email

  private

  def send_welcome_email
    SendWelcomeEmailJob.perform_later('Headhunter', id)
  end
end
