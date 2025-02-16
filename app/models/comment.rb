# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :apply
  belongs_to :headhunter

  validates :body, presence: true
  validates :author_id, :author_type, presence: true

  enum status: { open: 0, restrict: 1, closed: 2 }

  scope :open, -> { where(status: :open) }
  scope :restrict, -> { where(status: :restrict) }
  scope :closed, ->(author_id) { where(author_type: 'Headhunter', author_id:, status: :private) }

  def author_name
    author.name
  end

  def author
    author_type.constantize.find(author_id)
  end
end
