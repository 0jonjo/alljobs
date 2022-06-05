require 'rails_helper'

describe 'Headhunter see all profiles' do
  it 'with sucess' do
    user1 = User.create!(:email => 'user1@test.com', :password => 'test123')
    user2 = User.create!(:email => 'user2@test.com', :password => 'test123')
    user3 = User.create!(:email => 'user3@test.com', :password => 'test123')
    Profile.create!(name: "Tester", birthdate: "1991-12-12", description: "Tester 3", educacional_background: "Tester 3", experience: "Tester 3", user_id: user1.id)
    Profile.create!(name: "Tester2", birthdate: "1991-12-12", description: "Tester 3", educacional_background: "Tester 3", experience: "Tester 3", user_id: user2.id)
    Profile.create!(name: "Tester3", birthdate: "1991-12-12", description: "Tester 3", educacional_background: "Tester 3", experience: "Tester 3", user_id: user3.id)
    headhunter = Headhunter.create!(:email => 'admin@test.com', :password => 'test123')
    login_as(headhunter, :scope => :headhunter)
    
    visit root_path
    within('nav') do
      click_on 'Profiles'
    end

    expect(current_path).to eq profiles_path
    expect(page).to have_content('Profiles')
    expect(page).to have_content('1') 
    expect(page).to have_content('Tester') 
    expect(page).to have_content('2') 
    expect(page).to have_content('Tester2')
    expect(page).to have_content('3') 
    expect(page).to have_content('Tester3')  
    expect(page).not_to have_content('There are no profiles registered') 
  end

  it "with no one profile registered" do
    headhunter = Headhunter.create!(:email => 'admin@test.com', :password => 'test123')
    login_as(headhunter, :scope => :headhunter)
      
    visit root_path
    click_on 'Profiles'
    
    expect(current_path).to eq profiles_path
    expect(page).to have_content('There are no profiles registered') 
  end  
end
