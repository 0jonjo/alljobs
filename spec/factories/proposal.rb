FactoryBot.define do
    factory :proposal do
      salary { Faker::Number.number(digits: 4) }
      benefits { Faker::Job.field }
      expectations { Faker::Job.field }
      expected_start { Faker::Date.forward(days: 30) }
      association :apply
    end
  end