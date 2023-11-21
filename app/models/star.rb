# frozen_string_literal: true

class Star < ApplicationRecord
  belongs_to :headhunter
  belongs_to :apply

  validates :headhunter_id, :apply_id, presence: true
end
