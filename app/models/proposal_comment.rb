# frozen_string_literal: true

class ProposalComment < ApplicationRecord
  belongs_to :proposal

  validates :body, :proposal_id, presence: true
end
