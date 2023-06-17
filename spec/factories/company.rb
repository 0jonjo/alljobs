FactoryBot.define do
  factory :company do
    name { Faker::Company.name }
    description { Faker::Company.catch_phrase }
    website { Faker::Internet.domain_name }
    email { Faker::Internet.email }
    phone { Faker::PhoneNumber.phone_number }
  end
end