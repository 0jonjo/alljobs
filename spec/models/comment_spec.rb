require 'rails_helper'

RSpec.describe Comment, type: :model do
    it "body is mandatory" do
      user = User.create!(:email => 'user@test.com', :password => 'test123')
      headhunter = Headhunter.create!(:email => 'admin@test.com', :password => 'test123')
      profile = Profile.create!(name: 'Teste', social_name: 'Just a test 2', 
                                birthdate: '21/03/1977', educacional_background: "Test 3", 
                                experience: 'Test 3', user_id: user.id)
      comment = Comment.new(profile_id: profile.id, headhunter_id: headhunter.id,
                             datetime: Time.now, body: '')
      expect(comment.valid?).to eq false 
    end

    it "body is mandatory" do
      user = User.create!(:email => 'user@test.com', :password => 'test123')
      headhunter = Headhunter.create!(:email => 'admin@test.com', :password => 'test123')
      profile = Profile.create!(name: 'Teste', social_name: 'Just a test 2', 
                                birthdate: '21/03/1977', educacional_background: "Test 3", 
                                experience: 'Test 3', user_id: user.id)
      comment = Comment.new(profile_id: profile.id, headhunter_id: headhunter.id,
                             datetime: '', body: 'Test')
      expect(comment.valid?).to eq false 
    end
end
