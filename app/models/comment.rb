class Comment < ApplicationRecord
  belongs_to :profile
  belongs_to :headhunter
  accepts_nested_attributes_for :profile
  accepts_nested_attributes_for :headhunter
  validates :body, :datetime, presence: true
end
