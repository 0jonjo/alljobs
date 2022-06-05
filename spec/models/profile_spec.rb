require 'rails_helper'

RSpec.describe Profile, type: :model do
    describe "#valid?" do
      it "name is mandatory" do
        user = User.create!(:email => 'user@test.com', :password => 'test123')
        profile = Profile.new(name: '', social_name: 'Just a test 2', birthdate: '21/03/1977',
                              educacional_background: "Test 3", experience: 'test 4', user_id: user.id)
        expect(profile.valid?).to eq false                       
      end

      it "birthdate is mandatory" do
        user = User.create!(:email => 'user@test.com', :password => 'test123')
        profile = Profile.new(name: 'Test', social_name: 'Just a test 2', birthdate: '',
                              educacional_background: "Test 3", experience: 'test 4', user_id: user.id)
        expect(profile.valid?).to eq false 
      end

      it "educational background is mandatory" do
        user = User.create!(:email => 'user@test.com', :password => 'test123')
        profile = Profile.new(name: 'Teste', social_name: 'Just a test 2', birthdate: '21/03/1977',
                              educacional_background: "", experience: 'test 4', user_id: user.id)
        expect(profile.valid?).to eq false 
      end

      it "experience is mandatory" do
        user = User.create!(:email => 'user@test.com', :password => 'test123')
        profile = Profile.new(name: 'Teste', social_name: 'Just a test 2', birthdate: '21/03/1977',
                              educacional_background: "Test 3", experience: '', user_id: user.id)
        expect(profile.valid?).to eq false 
      end
      
      it "user_id is mandatory" do
        user = User.create!(:email => 'user@test.com', :password => 'test123')
        profile = Profile.new(name: 'Teste', social_name: 'Just a test 2', birthdate: '21/03/1977',
                              educacional_background: "Test 3", experience: 'Test 4', user_id: '')
        expect(profile.valid?).to eq false 
      end

      it "user_id is uniquess" do
        user = User.create!(:email => 'user@test.com', :password => 'test123')
        profile = Profile.create!(name: 'Teste', social_name: 'Just a test 2', birthdate: '21/03/1977',
                              educacional_background: "Test 3", experience: 'Test 4', user_id: user.id)
        profile2 = Profile.new(name: 'Teste', social_name: 'Just a test 2', birthdate: '21/03/1977',
                              educacional_background: "Test 3", experience: 'Test 4', user_id: user.id)                      
        expect(profile2.valid?).to eq false
      end   
    end    
end
