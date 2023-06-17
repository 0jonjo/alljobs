FactoryBot.define do
  factory :country do
    acronym { Faker::Address.country_code }
    name { Faker::Address.country }
  end
end