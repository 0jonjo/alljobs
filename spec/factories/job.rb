FactoryBot.define do
  factory :job do
    title { Faker::Job.title }
    description { Faker::Job.field }
    skills { Faker::Job.key_skill }
    salary { 999 }
    level { Faker::Job.seniority }
    date { Faker::Date.forward(days: 30) }
    code { '12345678' }
    job_status { 1 }
    city { Faker::Address.city }
    association :country
    association :company
  end
end