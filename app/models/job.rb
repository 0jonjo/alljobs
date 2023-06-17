class Job < ApplicationRecord
  belongs_to :country
  belongs_to :company
  has_many :applies
  has_many :users, through: :applies
  validates :title, :description, :skills, :salary, :company, :level, :country, :city, :date, presence: true
  validates :salary, numericality: { only_decimal: true }
  validates :code, uniqueness: true
  validate :job_date_is_future

  before_validation :generate_code, on: :create
  after_update :clean_up

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

  def clean_up
    if self.draft?
      ApplyListJob.perform_later(self.id)
    end
  end
  handle_asynchronously :clean_up
end
