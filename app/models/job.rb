class Job < ApplicationRecord
  has_many :applies
  has_many :users, through: :applies
  validates :title, :description, :skills, :salary, :company, :level, :place, :date, presence: true
  validates :salary, numericality: { only_decimal: true }

  before_create :generate_code
  
  private
  def generate_code
  end  
end
