class Job < ApplicationRecord
  has_many :applies
  has_many :users, through: :applies
  validates :title, :code, :description, :skills, :salary, :company, :level, :place, :date, presence: true
  validates :salary, numericality: { only_decimal: true }
  validates :code, uniqueness: true
  validate :job_date_is_future

  before_validation :generate_code

  enum job_status: { draft: 0, published: 1, archived: 9 }
  
  private
  def generate_code
    self.code = SecureRandom.alphanumeric(8).capitalize
  end  

  def job_date_is_future
    if self.date.present? && self.date <= Date.today
      self.errors.add(:date, " date can't be in past or today.")
    end    
  end  
end
