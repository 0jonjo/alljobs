# frozen_string_literal: true

class FeedbackApply < ApplicationRecord
  belongs_to :apply

  validates :apply_id, presence: true
end
