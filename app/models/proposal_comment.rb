# frozen_string_literal: true

class ProposalComment < ApplicationRecord
  belongs_to :proposal

  validates :body, :proposal_id, presence: true

  scope :by_proposal_id, ->(proposal_id) { where(proposal_id: proposal_id) }
end
