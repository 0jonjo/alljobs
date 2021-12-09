class Job < ApplicationRecord
  has_many :applies
  has_many :users, through: :applies 
end
