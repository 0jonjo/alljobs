# frozen_string_literal: true

class Job < ApplicationRecord
  belongs_to :country
  belongs_to :company
  has_many :applies, dependent: :destroy
  has_many :users, through: :applies
  validates :title, :description, :skills, :salary, :level, :city, :date, presence: true
  validates :salary, numericality: { only_decimal: true }
  validates :code, length: { is: 8 }, uniqueness: true
  validate :job_date_is_future

  before_validation :generate_code, on: :create
  after_update :clean_up

  enum :job_status, { draft: 0, published: 1, archived: 2 }
  enum :level, { junior: 0, mid_level: 1, senior: 2, specialist: 3 }
  enum :work_mode, { on_site: 0, remote: 1, hybrid: 2 }
  enum :contract_type, { full_time: 0, part_time: 1, contract: 2, freelance: 3 }

  scope :search, ->(title) { where('LOWER(title) LIKE ?', "%#{title.downcase}%") if title.present? }
  scope :sorted_id, -> { order(:id) }
  scope :indexed, ->(status) { where(job_status: status).sorted_id }
  scope :by_level, ->(level) { where(level:) if level.present? }
  scope :by_work_mode, ->(work_mode) { where(work_mode:) if work_mode.present? }
  scope :by_country, ->(country_id) { where(country_id:) if country_id.present? }
  scope :published, -> { where(job_status: :published) }
  scope :search_web, lambda { |term|
                       where('LOWER(code) LIKE :search OR LOWER(title) LIKE :search OR LOWER(description)
                                 LIKE :search', search: "%#{term.downcase}%")
                     }

  def stars(headhunter_id)
    Star.joins(:apply).where(applies: { job_id: id }, headhunter_id:)
  end

  def job_date_is_future
    return unless date.present? && date <= Time.zone.today

    errors.add(:date, " date can't be in past or today.")
  end

  def clean_up
    return unless draft?

    ApplyListJob.perform_later(id)
  end

  private

  def generate_code
    self.code = SecureRandom.alphanumeric(8).capitalize
  end
end
