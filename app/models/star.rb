# frozen_string_literal: true

class Star < ApplicationRecord
  belongs_to :headhunter
  belongs_to :apply

  validates :headhunter_id, :apply_id, presence: true

  scope :filtered_by_ids, ->(headhunter_id, apply_id) { where(headhunter_id:, apply_id:) }
  scope :filtered_by_headhunter, ->(headhunter_id) { where(headhunter_id:) }
end
