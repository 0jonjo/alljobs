class Comment < ApplicationRecord
  belongs_to :profile
  belongs_to :headhunter
  validates :body, presence: true
end
