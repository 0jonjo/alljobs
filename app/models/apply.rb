# frozen_string_literal: true

class Apply < ApplicationRecord
  belongs_to :job
  belongs_to :user
  has_many :stars, dependent: :destroy
  has_many :comments, dependent: :destroy

  scope :sorted_id, -> { order(:id) }
  scope :applied_by_user, ->(job_id, user_id) { where(job_id:, user_id:) }

  delegate :email, to: :user, prefix: true

  after_create_commit :send_apply_confirmed_email

  private

  def send_apply_confirmed_email
    SendApplyConfirmedEmailJob.perform_later(id)
  end
end
