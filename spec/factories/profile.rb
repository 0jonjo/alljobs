FactoryBot.define do
  factory :profile do
    name { Faker::Name.name }
    social_name { Faker::Name.name }
    birthdate { Faker::Date.birthday(min_age: 18) }
    description { Faker::Adjective.positive }
    educacional_background { Faker::Educator.degree }
    experience { Faker::Job.title }
    city { Faker::Address.city }
    association :country
    association :user
  end
end