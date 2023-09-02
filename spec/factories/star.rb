# frozen_string_literal: true

FactoryBot.define do
  factory :star do
    association :headhunter
    association :apply
  end
end
