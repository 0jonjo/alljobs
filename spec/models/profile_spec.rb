# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Profile, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:birthdate) }
  it { should validate_presence_of(:educacional_background) }
  it { should validate_presence_of(:experience) }
  it { should validate_presence_of(:country_id) }
  it { should validate_presence_of(:user_id) }

  describe 'scopes' do
    describe '.find_by_user_id' do
      let!(:profile1) { create(:profile) }
      let!(:profile2) { create(:profile) }

      it 'returns profile with matching user_id' do
        expect(Profile.find_by(user_id: profile1.user_id)).to eq(profile1)
      end

      it 'does not return profile with non-matching user_id' do
        expect(Profile.find_by(user_id: 9_999_999_999)).to be_nil
      end
    end
  end

  context 'Custom validation of' do
    it 'birthdate meets legal age' do
      profile2 = build(:profile, birthdate: 17.years.ago)
      profile2.valid?
      expect(profile2.errors.include?(:birthdate)).to be true
    end
  end
end
