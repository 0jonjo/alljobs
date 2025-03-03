# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    body { 'Test comment on a apply.' }
    association :apply
    association :author, factory: :headhunter
  end
end
