# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :apply
  belongs_to :author, polymorphic: true

  validates :body, presence: true
  validates :author_id, :author_type, presence: true

  enum :status, %i[open restrict closed]

  scope :by_apply, ->(apply_id) { where(apply_id: apply_id).where.not(status: :closed) }
  scope :for_headhunter, ->(headhunter_id) { where(status: :closed, author_type: 'Headhunter', author_id: headhunter_id) }

  def author_name
    author.name
  end

  def author
    author_type.constantize.find(author_id)
  end
end
