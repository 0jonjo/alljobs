FactoryBot.define do
    factory :star do
      association :headhunter
      association :apply
    end
  end