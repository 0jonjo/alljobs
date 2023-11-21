# frozen_string_literal: true

class Country < ApplicationRecord
  has_many :profiles
  has_many :jobs

  validates :acronym, :name, presence: true
end
