# frozen_string_literal: true

class Apply < ApplicationRecord
  belongs_to :job
  belongs_to :user
  has_one :proposal
  has_one :star

  validates :job_id, :user_id, presence: true

  scope :sorted_id, -> { order(:id) }
  scope :applied_by_user, ->(job_id, user_id) { where(job_id: job_id, user_id: user_id) }

  def user_email
    @user = User.find(user_id)
    @user.email.to_s
  end
end
