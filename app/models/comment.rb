# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :apply
  belongs_to :author, polymorphic: true

  validates :body, presence: true
  validates :author_type, presence: true

  enum :status, { open: 0, restrict: 1, closed: 2 }

  scope :by_apply, ->(apply_id) { where(apply_id: apply_id).where.not(status: :closed) }
  scope :for_headhunter, ->(headhunter_id) { where(status: :closed, author_type: 'Headhunter', author_id: headhunter_id) }
end
