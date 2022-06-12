require 'rails_helper'

describe 'Headhunter stars a profile' do
  xit 'and check it twice' do
    user = User.create!(:email => 'user@test.com', :password => 'test123')
    job =  Job.create!(title: 'Job Opening Test', description: 'Lorem ipsum dolor sit amet', 
                    skills: 'Nam mattis, felis ut adipiscing.', salary: '99',
                    company: 'Acme', level: 'Junior', place: 'Remote',
    date: '24/12/2099')
    profile = Profile.create!(name: "Tester", birthdate: "1991-12-12", description: "Tester 3",
                    educacional_background: "Tester 3", experience: "Tester 3", 
                    user_id: user.id)
    Apply.create!(:job => job, :user => user)             
    headhunter = Headhunter.create!(:email => 'admin@test.com', :password => 'test123')
    login_as(headhunter, :scope => :headhunter)
    visit root_path

    click_on 'Openings'
    click_on "Job Opening Test"
    click_on '1'
    click_on 'Star this profile'
    expect(page).to have_content("You successfully starred this profile.")
    click_on 'Star this profile'
    expect(page).to have_content("You're already starred this profile.")
  end
  
  it "see only a star profile" do
    user1 = User.create!(:email => 'user@test.com', :password => 'test123')
    Profile.create!(name: "Tester", birthdate: "1991-12-12", description: "Tester 3",
                    educacional_background: "Tester 3", experience: "Tester 3", 
                    user_id: user1.id)
    user2 = User.create!(:email => 'user2@test.com', :password => 'test123')
    Profile.create!(name: "Tester2", birthdate: "1991-12-12", description: "Tester 4",
                    educacional_background: "Tester 4", experience: "Tester 4", 
                    user_id: user2.id)
    headhunter = Headhunter.create!(:email => 'admin@test.com', :password => 'test123')
    login_as(headhunter, :scope => :headhunter)
    visit root_path
  
    click_on 'Profiles'
    click_on 'Tester'
    click_on 'Star this profile'

    within('nav') do
      click_on 'Stars'
    end

    expect(current_path).to eq stars_path
    expect(page).to have_content('Tester') 
    expect(page).to_not have_content('Tester2') 
  end

  it 'remove a star' do
    user = User.create!(:email => 'user@test.com', :password => 'test123')
    Profile.create!(name: "Tester", birthdate: "1991-12-12", description: "Tester 3",
                    educacional_background: "Tester 3", experience: "Tester 3", 
                    user_id: user.id)
    headhunter = Headhunter.create!(:email => 'admin@test.com', :password => 'test123')
    login_as(headhunter, :scope => :headhunter)
    visit root_path

    click_on 'Profiles'
    click_on 'Tester'
    click_on 'Star this profile'
    expect(page).to have_content('You successfully starred this profile.')
    click_on 'Stars'
    click_on 'Remove Star'
    expect(page).to have_content('You have removed the star from a profile')
  end
end

