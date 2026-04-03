# frozen_string_literal: true

class Apply < ApplicationRecord
  belongs_to :job
  belongs_to :user
  has_many :stars, dependent: :destroy
  has_many :comments, dependent: :destroy

  enum :status, { submitted: 0, reviewing: 1, shortlisted: 2, rejected: 3, hired: 4 }

  scope :sorted_id, -> { order(:id) }
  scope :applied_by_user, ->(job_id, user_id) { where(job_id:, user_id:) }

  delegate :email, to: :user, prefix: true
end
