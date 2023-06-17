FactoryBot.define do
    factory :admin do
      email { Faker::Internet.email  }
      password { Faker::Alphanumeric.alpha(number: 8) }
    end
  end