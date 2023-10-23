# frozen_string_literal: true

class ProposalComment < ApplicationRecord
  validates :body, presence: true
end
