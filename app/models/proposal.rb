# frozen_string_literal: true

class Proposal < ApplicationRecord
  belongs_to :apply
  has_many :feedback_applies
  validates :benefits, :expectations, :salary, :apply_id, presence: true
  validates :salary, numericality: { only_decimal: true }
  validate :proposal_expected_start_is_future

  def proposal_expected_start_is_future
    return unless expected_start.present? && expected_start < Date.today

    errors.add(:expected_start, " expected start can't be in past.")
  end
end
