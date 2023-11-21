# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :profile
  belongs_to :headhunter

  validates :body, :profile_id, :headhunter_id, presence: true
end
