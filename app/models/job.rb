# frozen_string_literal: true

class Job < ApplicationRecord
  belongs_to :country
  belongs_to :company
  has_many :applies, dependent: :destroy
  has_many :users, through: :applies
  validates :title, :description, :skills, :salary, :company, :level, :country, :city, :date, presence: true
  validates :salary, numericality: { only_decimal: true }
  validates :code, length: { is: 8 }
  validate :job_date_is_future

  before_validation :generate_code, on: :create
  after_update :clean_up

  enum :job_status, %i[draft published archived]
  enum :level, %i[junior mid_level senior specialist]

  scope :search, ->(title) { where('LOWER(title) LIKE ?', "%#{title.downcase}%") if title.present? }
  scope :sorted_id, -> { order(:id) }
  scope :indexed, ->(status) { where(job_status: status).sorted_id }
  scope :search_web, lambda { |term|
                       where('LOWER(code) LIKE :search OR LOWER(title) LIKE :search OR LOWER(description)
                                 LIKE :search', search: "%#{term.downcase}%")
                     }

  def stars(headhunter_id)
    applies.map { |apply| apply.stars.where(headhunter_id:) }.flatten
  end

  def generate_code
    generated_code = SecureRandom.alphanumeric(8).capitalize

    check_duplicated_code(generated_code)

    self.code = generated_code
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

  def check_duplicated_code(generated_code)
    return generated_code unless Job.find_by(code: generated_code)

    errors.add(:code, ' have to be unique.') if Job.find_by(code: generated_code)
  end
end
