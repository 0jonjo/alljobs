class Comment < ApplicationRecord
  belongs_to :profile
  belongs_to :headhunter
  validates :body, :datetime, presence: true
end
