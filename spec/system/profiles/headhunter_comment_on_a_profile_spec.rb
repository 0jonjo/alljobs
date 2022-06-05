require 'rails_helper'

describe 'Headhunter comment on a profile' do

  it 'and edit with sucess' do
    user = User.create!(:email => 'user@test.com', :password => 'test123')
    profile = Profile.create!(name: 'Tester', social_name: 'Tester', birthdate: '1999/09/09', description: "Profissional Tester", educacional_background: "Tester University Class 2021", experience: "Test things everyday since I was born", user_id: user.id)
    headhunter = Headhunter.create!(:email => 'admin@test.com', :password => 'test123')
    login_as(headhunter, :scope => :headhunter)
    
    visit root_path
    click_on 'Profiles'
    click_on 'Tester'
    
    expect(current_path).to eq profile_path(profile)

    fill_in 'Body', with: 'Just a test comment'
    click_on 'Create Comment'
    expect(page).to have_content('Just a test comment')
    expect(page).to have_content("Comment created.")

    click_on 'Edit'
    fill_in 'Body', with: 'Another test comment'
    click_on 'Update Comment'
    expect(page).to have_content('Comment updated.')
    expect(page).to have_content('Another test comment')
  end

  it "and write a second comment" do
    user = User.create!(:email => 'user@test.com', :password => 'test123')
    profile = Profile.create!(name: 'Tester', social_name: 'Tester', birthdate: '1999/09/09', description: "Profissional Tester", educacional_background: "Tester University Class 2021", experience: "Test things everyday since I was born", user_id: user.id)
    headhunter = Headhunter.create!(:email => 'admin@test.com', :password => 'test123')
    login_as(headhunter, :scope => :headhunter)
    
    visit root_path
    click_on 'Profiles'
    click_on 'Tester'
    expect(current_path).to eq profile_path(profile)

    fill_in 'Body', with: 'Just a test comment'
    click_on 'Create Comment'
    fill_in 'Body', with: 'Second comment'
    click_on 'Create Comment'

    expect(page).to have_content('Just a test comment')
    expect(page).to have_content('Second comment')
  end  

  it "and delete" do
    user = User.create!(:email => 'user@test.com', :password => 'test123')
    profile = Profile.create!(name: 'Tester', social_name: 'Tester', birthdate: '1999/09/09', description: "Profissional Tester", educacional_background: "Tester University Class 2021", experience: "Test things everyday since I was born", user_id: user.id)
    headhunter = Headhunter.create!(:email => 'admin@test.com', :password => 'test123')
    login_as(headhunter, :scope => :headhunter)
    
    visit root_path
    click_on 'Profiles'
    click_on 'Tester'
    expect(current_path).to eq profile_path(profile)

    fill_in 'Body', with: 'Just a test comment'
    click_on 'Create Comment'
    expect(page).to have_content('Just a test comment')

    click_on 'Delete'
    expect(page).not_to have_content('Just a test comment')
  end  
end
