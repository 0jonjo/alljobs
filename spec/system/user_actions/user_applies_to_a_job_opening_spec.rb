require 'rails_helper'

describe 'User apllies to a job opening' do
  it 'with sucess' do
    Job.create!(title: 'Job Opening Test 123', description: 'Lorem ipsum dolor sit amet', 
                skills: 'Nam mattis, felis ut adipiscing.', salary: '99', 
                company: 'Acme', level: 'Junior', place: 'Remote Job',
                date: 24/12/2099)
    user = User.create!(:email => 'user@test.com', :password => 'test123')
    login_as(user, :scope => :user)
    
    visit root_path
    within('nav') do
      click_on 'Openings'
    end  
    expect(page).to have_content('Job Opening Test 123')
    click_on 'Job Opening Test 123'
    
    click_on 'Apply for this Job'
    expect(page).to have_content('user@test.com')
    expect(page).to have_content('Job Opening Test 123')
  end

  it 'without sucess' do
    job = Job.create!(title: 'Job Opening Test 123', description: 'Lorem ipsum dolor sit amet', 
                  skills: 'Nam mattis, felis ut adipiscing.', salary: '99', 
                  company: 'Acme', level: 'Junior', place: 'Remote Job',
                  date: 24/12/2099)
    user = User.create!(:email => 'user@test.com', :password => 'test123')
    Apply.create!(:job => job, :user => user)
    login_as(user, :scope => :user)

    visit root_path
    click_on 'Openings'
    click_on 'Job Opening Test 123'
    click_on 'Apply for this Job'
    expect(page).to have_content("You're already applied to this job opening.")
  end  

  it "remove the apply" do
    job = Job.create!(title: 'Job Opening Test 123', description: 'Lorem ipsum dolor sit amet', 
    skills: 'Nam mattis, felis ut adipiscing.', salary: '99', 
    company: 'Acme', level: 'Junior', place: 'Remote Job',
    date: 24/12/2099)
    user = User.create!(:email => 'user@test.com', :password => 'test123')
    apply = Apply.create!(:job => job, :user => user)
    login_as(user, :scope => :user)

    visit apply_path(apply)
    click_on 'Remove Apply'
    expect(page).to have_content('The application for this job has been removed.')
  end  
end