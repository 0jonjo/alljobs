FactoryBot.define do
    factory :headhunter do
      email { Faker::Internet.email  }
      password { Faker::Alphanumeric.alpha(number: 8) }
    end
  end