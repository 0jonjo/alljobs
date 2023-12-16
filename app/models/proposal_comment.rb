# frozen_string_literal: true

class ProposalComment < ApplicationRecord
  belongs_to :proposal

  validates :body, :proposal_id, presence: true

  scope :by_proposal_id, ->(proposal_id) { where(proposal_id: proposal_id) }

  scope :by_author, ->(author_type, author_id) { where(author_type: author_type, author_id: author_id) }
end
