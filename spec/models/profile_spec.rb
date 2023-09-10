# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Profile, type: :model do

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:birthdate) }
  it { should validate_presence_of(:educacional_background) }
  it { should validate_presence_of(:experience) }
  it { should validate_presence_of(:country_id) }
  it { should validate_presence_of(:user_id) }

  context 'Custom validation of' do

    let(:profile) { create(:profile) }

    it 'user_id is uniquess' do
      profile2 = Profile.new(name: 'Teste', social_name: 'Just a test 2', birthdate: '21/03/1977',
                            educacional_background: 'Test 3', experience: 'Test 4',
                            user_id: profile.user_id, country: profile.country)
      profile2.valid?
      expect(profile2.errors.include?(:user_id)).to be true
    end

    it 'birthdate meet legal age' do
      profile2 = Profile.new(name: 'Teste', social_name: 'Just a test 2', birthdate: 17.years.ago,
                            educacional_background: 'Test 3', experience: 'Test 4',
                            user_id: profile.user_id, country: profile.country)
      profile2.valid?
      expect(profile2.errors.include?(:birthdate)).to be true
    end
  end
end
