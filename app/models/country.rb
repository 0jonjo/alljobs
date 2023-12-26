# frozen_string_literal: true

class Country < ApplicationRecord
  has_many :profiles, dependent: :destroy
  has_many :jobs, dependent: :destroy

  validates :acronym, :name, presence: true
end
