# frozen_string_literal: true

FactoryBot.define do
  factory :proposal_comment do
    body { 'Test comment on a proposal.' }
    author_id { 1 }
    author_type { 'Headhunter' }
    association :proposal
  end
end
