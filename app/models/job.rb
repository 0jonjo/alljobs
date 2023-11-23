# frozen_string_literal: true

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
  enum level: { junior: 0, mid_level: 1, senior: 7, specialist: 9 }

  scope :sorted_id, -> { order(:id) }

  private

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
