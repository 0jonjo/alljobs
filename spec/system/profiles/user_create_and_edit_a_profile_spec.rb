require 'rails_helper'

describe 'User create a profile' do   
  it 'with sucess' do
      user = User.create!(:email => 'user@test.com', :password => 'test123')
      login_as(user, :scope => :user)
      visit root_path
      within('nav') do
        click_on 'Profile'
      end 
      
      expect(current_path).to eq new_profile_path

      fill_in 'Name', with: 'User test name'
      fill_in 'Social name', with: 'Social name test'
      fill_in 'Birthdate', with: '31/12/1931'
      fill_in 'Description', with: 'Test 1'
      fill_in 'Educacional background', with: 'Test 2'
      fill_in 'Experience', with: 'Test 3'
      click_on 'Create Profile'

      expect(current_path).to eq profile_path(user)

      expect(page).to have_content "Profile registered."
      expect(page).not_to have_content 'User test name'
      expect(page).to have_content 'Social name test'
      expect(page).to have_content '1931-12-31'
      expect(page).to have_content 'Test 1'
      expect(page).to have_content 'Test 2'
      expect(page).to have_content 'Test 3'
  end

  it 'without sucess - forget some items' do
      user = User.create!(:email => 'user@test.com', :password => 'test123')
      login_as(user, :scope => :user)
      visit root_path
      click_on 'Profile'
    
      fill_in 'Name', with: ''
      fill_in 'Social name', with: ''
      fill_in 'Birthdate', with: ''
      fill_in 'Description', with: ''
      fill_in 'Educacional background', with: ''
      fill_in 'Experience', with: ''
      click_on 'Create Profile'
      
      expect(page).to have_content "Profile doesn't registered." 
      expect(current_path).to eq profiles_path
  end 
end   
      
describe 'User edit a profile' do
  it 'with sucess' do
        user = User.create!(:email => 'user@test.com', :password => 'test123')
        login_as(user, :scope => :user)
        profile = Profile.create!(name: 'Just a test', social_name: 'Just a test 2', birthdate: '21/03/1977',
                                  educacional_background: "Test 3", experience: 'test 4', user_id: user.id)
        visit root_path        
        click_on 'Profile'
        click_on 'Edit'

        expect(current_path).to eq edit_profile_path(user)

        fill_in 'Name', with: 'User test name'
        fill_in 'Social name', with: 'Social name test'
        fill_in 'Birthdate', with: '01/01/1900'
        fill_in 'Description', with: 'Test1'
        fill_in 'Educacional background', with: 'Test2'
        fill_in 'Experience', with: 'Test3'

        click_on 'Update Profile'
        expect(current_path).to eq profile_path(user)
        
        expect(page).not_to have_content 'User test name'
        expect(page).not_to have_content 'Just a test 2'

        expect(page).to have_content 'Social name test'
        expect(page).to have_content '1900-01-01'
        expect(page).to have_content 'Test1'
        expect(page).to have_content 'Test2'
        expect(page).to have_content 'Test3'
      end

  it 'without sucess' do
        user = User.create!(:email => 'user@test.com', :password => 'test123')
        login_as(user, :scope => :user)
        profile = Profile.create!(name: 'Just a test', social_name: 'Just a test 2', birthdate: '21/03/1977',
                                  educacional_background: "Test 3", experience: 'test 4', user_id: user.id)
        visit root_path        
        click_on 'Profile'
        click_on 'Edit'

        expect(current_path).to eq edit_profile_path(user)

        fill_in 'Name', with: ''
        fill_in 'Social name', with: ''
        fill_in 'Birthdate', with: ''
        fill_in 'Description', with: ''
        fill_in 'Educacional background', with: ''
        fill_in 'Experience', with: ''
        click_on 'Update Profile'

        expect(current_path).to eq profile_path(user)
        expect(page).to have_content "Profile doesn't edited."
      end  
end