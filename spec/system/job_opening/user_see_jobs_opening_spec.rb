require 'rails_helper'

describe 'User see job openings' do
  it 'with sucess - only published' do
    job1 = Job.create!(title: 'Test 123', description: 'Lorem ipsum dolor sit amet', 
                        skills: 'Nam mattis, felis ut adipiscing.', salary: '99', 
                        company: 'Acme', level: 'Junior', place: 'Remote Job',
                        date: 1.month.from_now)
    job2 = Job.create!(title: 'Test 456', description: 'Lorem ipsum dolor sit amet', 
                        skills: 'Nam mattis, felis ut adipiscing.', salary: '99', 
                        company: 'Acme', level: 'Junior', place: 'Remote Job',
                        date: 1.month.from_now)
    job3 = Job.create!(title: 'Test 789', description: 'Lorem ipsum dolor sit amet', 
                        skills: 'Nam mattis, felis ut adipiscing.', salary: '99', 
                        company: 'Acme', level: 'Junior', place: 'Remote Job',
                        date: 1.month.from_now, job_status: :archived) 
    job4 = Job.create!(title: 'Test 101112', description: 'Lorem ipsum dolor sit amet', 
                        skills: 'Nam mattis, felis ut adipiscing.', salary: '99', 
                        company: 'Acme', level: 'Junior', place: 'Remote Job',
                        date: 1.month.from_now, job_status: :draft)                                                           
    user = User.create!(:email => 'user@test.com', :password => 'test123')
    profile = Profile.create!(name: 'Just a test', social_name: 'Just a test 2', 
                              birthdate: '21/03/1977', educacional_background: "Test 3", 
                              experience: 'test 4', user_id: user.id)
    login_as(user, :scope => :user)
    visit jobs_path
  
    expect(page).to have_content('Test 123')
    expect(page).to have_content('Test 456')
    expect(page).not_to have_content('Test 789')
    expect(page).not_to have_content('Test 101112')
  end

  it 'without sucess - no one job' do                                                           
    user = User.create!(:email => 'user@test.com', :password => 'test123')
    profile = Profile.create!(name: 'Just a test', social_name: 'Just a test 2', 
                              birthdate: '21/03/1977', educacional_background: "Test 3", 
                              experience: 'test 4', user_id: user.id)
    login_as(user, :scope => :user)
    visit jobs_path   
    
    expect(page).to have_content(I18n.t('no_jobs'))
  end  
end