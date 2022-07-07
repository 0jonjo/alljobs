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
    headhunter = Headhunter.create!(:email => 'headhunter@test.com', :password => 'test123')
    login_as(headhunter, :scope => :headhunter)
    visit jobs_path
  
    expect(page).to have_content('Test 123')
    expect(page).to have_content('Test 456')
    expect(page).not_to have_content('Test 789')
    expect(page).not_to have_content('Test 101112')
  end

  it 'without sucess - no one job' do                                                           
    headhunter = Headhunter.create!(:email => 'headhunter@test.com', :password => 'test123')
    login_as(headhunter, :scope => :headhunter)
    visit jobs_path
      
    expect(page).to have_content('There are not any job opening published.')
  end  
end