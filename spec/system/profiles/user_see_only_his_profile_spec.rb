require 'rails_helper'

describe 'User see his profile' do
  it 'with sucess' do
    user = User.create!(:email => 'user@test.com', :password => 'test123')
    profile = Profile.create!(name: 'Just a test', social_name: 'Just a test 2', 
                              birthdate: '21/03/1977', educacional_background: "Test 3", 
                              experience: 'test 4', user_id: user.id)    
    login_as(user, :scope => :user)  
    visit root_path    
    
    click_on "Profile"
    expect(current_path).to eq(profile_path(user.id))
  end

  it 'without sucess because do not have a profile' do
    user = User.create!(:email => 'user@test.com', :password => 'test123')  
    login_as(user, :scope => :user)  
    visit root_path    
    
    click_on "Profile"
    expect(current_path).to eq(new_profile_path)
  end

  it 'without sucess because is not his profile' do
    user = User.create!(:email => 'user@test.com', :password => 'test123')
    user2 = User.create!(:email => 'user2@test.com', :password => 'test123')
    profile = Profile.create!(name: 'Just a test', social_name: 'Just a test 2', 
                              birthdate: '21/03/1977', educacional_background: "Test 3", 
                              experience: 'test 4', user_id: user2.id)    
    login_as(user, :scope => :user)     
    visit profile_path(user.id)

    expect(current_path).to eq(root_path)
    expect(page).to have_content('You do not have access to this profile.')
  end
end        