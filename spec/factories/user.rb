FactoryBot.define do
    factory :user do
      email { Faker::Internet.email }
      password { Faker::Alphanumeric.alpha(number: 8) }
    end
  end