# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :apply
  belongs_to :headhunter

  validates :body, presence: true
end
