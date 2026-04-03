# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :profile, dependent: :destroy
  has_many :applies, dependent: :destroy
  has_many :jobs, through: :applies

  after_create_commit :send_welcome_email

  private

  def send_welcome_email
    SendWelcomeEmailJob.perform_later('User', id)
  end
end
