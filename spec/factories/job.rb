# frozen_string_literal: true

FactoryBot.define do
  factory :job do
    title { Faker::Job.title }
    description { Faker::Job.field }
    skills { Faker::Job.key_skill }
    salary { Faker::Number.number(digits: 4) }
    level { Faker::Job.seniority }
    date { Faker::Date.forward(days: 30) }
    code { Faker::Alphanumeric.alpha(number: 8).upcase }
    job_status { 1 }
    city { Faker::Address.city }
    association :country
    association :company
  end
end
