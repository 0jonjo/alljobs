FactoryBot.define do
    factory :comment do
      body { 'Test comment on a profile.' }
      association :profile
      association :headhunter
    end
  end