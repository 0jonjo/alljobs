# frozen_string_literal: true

class Headhunter < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :comments, dependent: :destroy
  has_many :profiles, through: :comments
  has_many :proposal_comments, as: :author, dependent: :destroy
  has_many :stars, dependent: :destroy
  has_many :profiles, through: :stars
end
