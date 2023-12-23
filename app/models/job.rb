# frozen_string_literal: true

class Job < ApplicationRecord
  belongs_to :country
  belongs_to :company
  has_many :applies
  has_many :users, through: :applies
  validates :title, :description, :skills, :salary, :company, :level, :country, :city, :date, presence: true
  validates :salary, numericality: { only_decimal: true }
  validates :code, uniqueness: true, length: { is: 8 }
  validate :job_date_is_future

  before_validation :generate_code, on: :create
  after_update :clean_up

  enum job_status: { draft: 0, published: 1, archived: 9 }
  enum level: { junior: 0, mid_level: 1, senior: 7, specialist: 9 }

  scope :search, ->(term) { where('LOWER(title) LIKE ?', "%#{term.downcase}%") if term.present? }
  scope :sorted_id, -> { order(:id) }
  scope :indexed, ->(status) { where(job_status: status).sorted_id }
  scope :search_web, lambda { |term|
                       where('LOWER(code) LIKE :search OR LOWER(title) LIKE :search OR LOWER(description)
                                 LIKE :search', search: "%#{term.downcase}%")
                     }

  def generate_code
    self.code = SecureRandom.alphanumeric(8).capitalize
  end

  def job_date_is_future
    return unless date.present? && date <= Date.today

    errors.add(:date, " date can't be in past or today.")
  end

  def clean_up
    return unless draft?

    ApplyListJob.perform_async(id)
  end
end
