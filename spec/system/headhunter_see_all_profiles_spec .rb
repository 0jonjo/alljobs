require 'rails_helper'

describe 'Visit the homepage as Headhunter' do

  it 'see all profiles' do
  
    Profile.new(name: 'Tester', social_name: 'Super Tester', birthdate: 1999/09/09, description: "Profissional Tester", educacional_background: "Tester University Class 2021", experience: "Test things everyday since I was born").save 

    headhunter = Headhunter.create!(:email => 'usuario@disco1995.com.br', :password => 'd2blackalien')
    login_as(headhunter, :scope => :headhunter)
    visit root_path

    click_on 'All Profiles'

    expect(page).to have_content('Profiles')
    expect(page).to have_content('Name: Tester')
    expect(page).to have_content('ID: 1') 
    visit root_path
  end
end
