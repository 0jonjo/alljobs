require 'rails_helper'

describe 'Headhunter rejects an apply' do
  it 'with sucess' do
    user = User.create!(:email => 'user@test.com', :password => 'test123')
    job =  Job.create!(title: 'Job Opening Test', description: 'Lorem ipsum dolor sit amet', 
                    skills: 'Nam mattis, felis ut adipiscing.', salary: '99',
                    company: 'Acme', level: 'Junior', place: 'Remote',
                    date: 1.month.from_now)
    profile = Profile.create!(name: "Tester", birthdate: "1991-12-12", description: "Tester 3",
                    educacional_background: "Tester 3", experience: "Tester 3", 
                    user_id: user.id)
    apply = Apply.create!(:job => job, :user => user)             
    headhunter = Headhunter.create!(:email => 'admin@test.com', :password => 'test123')
    login_as(headhunter, :scope => :headhunter)
    visit apply_path(apply)

    click_on "Reject This Apply"
    fill_in "Feedback headhunter", with: "You need more experience to this job."
    click_on "Update Apply"
    
    expect(current_path).to eq(apply_path(apply))
    expect(page).to have_content("You successfully rejected this apply.")
    expect(page).to have_content("This application for a job offer was rejected.")
    expect(page).to have_content("You need more experience to this job.")
  end
  
  it "user see his reject" do
    user = User.create!(:email => 'user@test.com', :password => 'test123')
    user2 = User.create!(:email => 'user2@test.com', :password => 'test123')
    job =  Job.create!(title: 'Job Opening Test', description: 'Lorem ipsum dolor sit amet', 
                    skills: 'Nam mattis, felis ut adipiscing.', salary: '99',
                    company: 'Acme', level: 'Junior', place: 'Remote',
                    date: 1.month.from_now)
    profile = Profile.create!(name: "Tester", birthdate: "1991-12-12", description: "Tester 3",
                    educacional_background: "Tester 3", experience: "Tester 3", 
                    user_id: user.id)
    profile2 = Profile.create!(name: "Tester 2", birthdate: "1993-12-12", description: "Tester 34",
                    educacional_background: "Tester 4", experience: "Tester 34", 
                    user_id: user2.id)
    apply = Apply.create!(:job => job, :user => user)             
    headhunter = Headhunter.create!(:email => 'admin@test.com', :password => 'test123')
    Star.create!(:headhunter_id => headhunter.id, :profile_id => user.id, :apply_id => apply.id)
    login_as(headhunter, :scope => :headhunter)
    visit root_path
  
    within('nav') do
      click_on 'Stars'
    end

    expect(current_path).to eq stars_path
    expect(page).to have_content('Tester') 
    expect(page).to_not have_content('Tester2') 
  end

  it 'remove a star' do
    user1 = User.create!(:email => 'user@test.com', :password => 'test123')
    profile1 = Profile.create!(name: "Tester", birthdate: "1991-12-12", 
                                description: "Tester 3", educacional_background: "Tester 3", 
                                experience: "Tester 3", user_id: user1.id)
    user2 = User.create!(:email => 'user2@test.com', :password => 'test123')
    profile2 = Profile.create!(name: "Tester2", birthdate: "1991-12-12", description: "Tester 3",
                                educacional_background: "Tester 3", 
                                experience: "Tester 3", user_id: user2.id)
    headhunter = Headhunter.create!(:email => 'admin@test.com', :password => 'test123')
    job =  Job.create!(title: 'Job Opening Test', description: 'Lorem ipsum dolor sit amet', 
                        skills: 'Nam mattis, felis ut adipiscing.', salary: '99',
                        company: 'Acme', level: 'Junior', place: 'Remote',
                        date: 1.month.from_now)
    apply = Apply.create!(:job => job, :user => user1) 
    login_as(headhunter, :scope => :headhunter)
    Star.create!(profile_id: profile1.id, headhunter_id: headhunter.id, apply_id: apply.id)

    visit root_path
    click_on 'Stars'
    click_on "Remove Star"

    expect(page).to have_content('There is no apply selected as a star')
    expect(page).not_to have_content('Tester')
  end  
end

