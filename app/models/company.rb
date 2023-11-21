# frozen_string_literal: true

class Company < ApplicationRecord
  has_many :jobs

  validates :name, presence: true
end
