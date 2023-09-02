# frozen_string_literal: true

class Company < ApplicationRecord
  has_many :jobs
end
