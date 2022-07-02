require 'rails_helper'

describe "User try to acess a profile" do
  it "and are not his profile", :type => :request do
    user = User.create!(:email => 'user@test.com', :password => 'test123')
    user2 = User.create!(:email => 'user2@test.com', :password => 'test123')
    profile = Profile.create!(name: 'Just a test', social_name: 'Just a test 2', birthdate: '21/03/1977',
                                educacional_background: "Test 3", experience: 'test 4', 
                                user_id: user.id)
    
    login_as(user2, :scope => :user)
    get(profile_path(user))
    expect(response).to redirect_to(root_path)
  end  
end    

describe "User try to edit a profile" do
  it "and are not his profile", :type => :request do
    user = User.create!(:email => 'user@test.com', :password => 'test123')
    user2 = User.create!(:email => 'user2@test.com', :password => 'test123')
    profile = Profile.create!(name: 'Just a test', social_name: 'Just a test 2', birthdate: '21/03/1977',
                                educacional_background: "Test 3", experience: 'test 4', 
                                user_id: user.id)
    
    login_as(user2, :scope => :user)
    get(edit_profile_path(user))
    expect(response).to redirect_to(root_path)
  end  
end  