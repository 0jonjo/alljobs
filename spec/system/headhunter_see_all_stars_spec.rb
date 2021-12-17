require 'rails_helper'

describe 'Visit the homepage as Headhunter' do

  it 'see all stars' do
  
    User.create!(:email => 'user@user.com.br', :password => 'd2blackalien')
    Profile.create!(name: "Tester", birthdate: "1991-12-12", description: "Tester 3", educacional_background: "Tester 3", experience: "Tester 3", user_id: "1")

    headhunter = Headhunter.create!(:email => 'usuario@disco1995.com.br', :password => 'd2blackalien')
    login_as(headhunter, :scope => :headhunter)

    Star.create!(user_id: 1, headhunter_id: 1)

    visit root_path

    click_on 'Stars'

    expect(page).to have_content('Stars')
    expect(page).to have_content('ID: 1') 
    expect(page).to have_content('Tester') 

  end
end
