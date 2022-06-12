class Job < ApplicationRecord
  has_many :applies
  has_many :users, through: :applies
  validates :title, :code, :description, :skills, :salary, :company, :level, :place, :date, presence: true
  validates :salary, numericality: { only_decimal: true }
  validates :code, uniqueness: true

  before_validation :generate_code
  
  private
  def generate_code
    self.code = SecureRandom.alphanumeric(8).capitalize
  end  
end
