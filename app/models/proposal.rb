class Proposal < ApplicationRecord
  belongs_to :apply
  validates :benefits, :expectations, :salary, :apply_id, presence: true
  validates :salary, numericality: { only_decimal: true }  
end
