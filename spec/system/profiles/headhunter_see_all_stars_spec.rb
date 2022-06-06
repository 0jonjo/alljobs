require 'rails_helper'

describe 'Headhunter see all his stars' do
  it 'with sucess' do
    user1 = User.create!(:email => 'user@test.com', :password => 'test123')
    profile1 = Profile.create!(name: "Tester", birthdate: "1991-12-12", 
                                description: "Tester 3", educacional_background: "Tester 3", 
                                experience: "Tester 3", user_id: user1.id)
    user2 = User.create!(:email => 'user2@test.com', :password => 'test123')
    profile2 = Profile.create!(name: "Tester2", birthdate: "1991-12-12", description: "Tester 3",
                                educacional_background: "Tester 3", 
                                experience: "Tester 3", user_id: user2.id)
    headhunter = Headhunter.create!(:email => 'admin@test.com', :password => 'test123')
    login_as(headhunter, :scope => :headhunter)
    Star.create!(profile_id: profile1.id, headhunter_id: headhunter.id)

    visit root_path
    click_on 'Stars'

    expect(page).to have_content('Stars')
    expect(page).to have_content('1') 
    expect(page).to have_content('Tester') 
    expect(page).not_to have_content('2')
    expect(page).not_to have_content('Tester2')
  end

  it 'without sucess because there arent any star profile' do
    user = User.create!(:email => 'user@test.com', :password => 'test123')
    profile = Profile.create!(name: "Tester", birthdate: "1991-12-12", description: "Tester 3", educacional_background: "Tester 3", experience: "Tester 3", user_id: user.id)
    headhunter = Headhunter.create!(:email => 'admin@test.com', :password => 'test123')
    login_as(headhunter, :scope => :headhunter)
  
    visit root_path
    click_on 'Stars'

    expect(page).to have_content('There is no profile selected as a star.')
    expect(page).not_to have_content('Tester') 
  end

  it 'without sucess because there arent any star profile to this headhunter' do
    user = User.create!(:email => 'user@test.com', :password => 'test123')
    profile = Profile.create!(name: "Tester", birthdate: "1991-12-12", description: "Tester 3", educacional_background: "Tester 3", experience: "Tester 3", user_id: user.id)
    headhunter1 = Headhunter.create!(:email => 'admin@test.com', :password => 'test123')
    headhunter2 = Headhunter.create!(:email => 'admin2@test.com', :password => 'test123')
    Star.create!(profile_id: profile.id, headhunter_id: headhunter2.id)
    login_as(headhunter1, :scope => :headhunter)
  
    visit root_path
    click_on 'Stars'

    expect(page).to have_content('There is no profile selected as a star.')
    expect(page).not_to have_content('Tester') 
  end
end
