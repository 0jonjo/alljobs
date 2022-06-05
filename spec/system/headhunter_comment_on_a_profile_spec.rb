require 'rails_helper'

describe 'Visit the homepage as Headhunter' do

  it 'see all profiles and do/edit a comment' do
    
    User.create!(:email => 'user@user.com.br', :password => 'd2blackalien')
    Profile.new(name: 'Tester', social_name: 'Super Tester', birthdate: '1999/09/09', description: "Profissional Tester", educacional_background: "Tester University Class 2021", experience: "Test things everyday since I was born", user_id: 1).save 

    headhunter = Headhunter.create!(:email => 'usuario@disco1995.com.br', :password => 'd2blackalien')
    login_as(headhunter, :scope => :headhunter)
    visit root_path

    click_on 'Profiles'
    click_on 'Super Tester'

    expect(page).to have_content('1999-09-09') 
    fill_in 'Body', with: 'Just a test comment'
    click_on 'Create Comment'
    expect(page).to have_content('Just a test comment')

    click_on 'Edit'
    fill_in 'Body', with: 'Another test comment'
    click_on 'Update Comment'
    expect(page).to have_content('Another test comment')
  end
end
