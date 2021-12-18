require 'rails_helper'

describe 'Visit the homepage as Headhunter' do

  it 'stars a profile check it and remove from stars' do
  
    User.create!(:email => 'user@user.com.br', :password => 'd2blackalien')
    Profile.create!(name: "Tester", birthdate: "1991-12-12", description: "Tester 3", educacional_background: "Tester 3", experience: "Tester 3", user_id: "1")

    headhunter = Headhunter.create!(:email => 'usuario@disco1995.com.br', :password => 'd2blackalien')
    login_as(headhunter, :scope => :headhunter)

    visit root_path

    click_on 'Profiles'
    click_on 'Tester'
    click_on 'Star this profile'
    expect(page).to have_content("You successfully starred this profile.")
    click_on 'Star this profile'
    expect(page).to have_content("You're already starred this profile.")
    
    click_on 'Stars' 
    expect(page).to have_content('Tester') 

    click_on 'Remove'
    expect(page).to_not have_content('Tester') 
  end
end
