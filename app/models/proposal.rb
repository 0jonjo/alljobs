# frozen_string_literal: true

class Proposal < ApplicationRecord
  belongs_to :apply
  validates :benefits, :expectations, :salary, :apply_id, presence: true
  validates :salary, numericality: { only_decimal: true }
  validate :proposal_expected_start_is_future

  scope :by_apply_id, ->(apply_id) { where(apply_id:) }

  def proposal_expected_start_is_future
    return unless expected_start.present? && expected_start < Time.zone.today

    errors.add(:expected_start, " expected start can't be in past.")
  end

  def send_mail_success(profile_id, path)
    SendMailSuccessUserJob.perform_async(profile_id, 'accepted this proposal', path)
  end
end
