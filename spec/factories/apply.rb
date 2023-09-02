# frozen_string_literal: true

FactoryBot.define do
  factory :apply do
    association :user
    association :job
  end
end
