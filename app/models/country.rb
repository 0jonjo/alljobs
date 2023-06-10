class Country < ApplicationRecord
  has_many :profiles
  has_many :jobs
end