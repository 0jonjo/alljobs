# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :profile
  belongs_to :headhunter

  validates :body, :profile_id, :headhunter_id, presence: true

  scope :comments_by_headhunter, ->(headhunter, profile) { where(headhunter: headhunter, profile: profile) }
end
