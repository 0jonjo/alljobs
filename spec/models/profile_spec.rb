require 'rails_helper'

RSpec.describe Profile, type: :model do
    describe "#valid?" do
      it "name is mandatory" do
        profile = Profile.new(name: '')
        profile.valid?
        expect(profile.errors.include?(:name)).to be true
      end

      it "birthdate is mandatory" do
        profile = Profile.new(birthdate: '')
        profile.valid?
        expect(profile.errors.include?(:birthdate)).to be true
      end

      it "educational background is mandatory" do
        profile = Profile.new(educacional_background: '')
        profile.valid?
        expect(profile.errors.include?(:educacional_background)).to be true
      end

      it "experience is mandatory" do
        profile = Profile.new(experience: '')
        profile.valid?
        expect(profile.errors.include?(:experience)).to be true
      end

      it "country is mandatory" do
        profile = Profile.new()
        profile.valid?
        expect(profile.errors.include?(:country)).to be true
      end

      it "user_id is mandatory" do
        profile = Profile.new(user_id: '')
        profile.valid?
        expect(profile.errors.include?(:user_id)).to be true 
      end

      it "user_id is uniquess" do
        profile = create(:profile)
        profile2 = Profile.new(name: 'Teste', social_name: 'Just a test 2', birthdate: '21/03/1977',
                              educacional_background: 'Test 3', experience: 'Test 4', user_id: profile.user_id, country: profile.country)                      
        profile2.valid?
        expect(profile2.errors.include?(:user_id)).to be true
      end
    end
end