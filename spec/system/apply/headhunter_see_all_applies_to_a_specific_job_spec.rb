require 'rails_helper'

describe 'Headhunter view applies to a specific job' do
  it 'with sucess' do
    job = Job.create!(title: 'Job Opening Test 123', description: 'Lorem ipsum dolor sit amet', 
                       skills: 'Nam mattis, felis ut adipiscing.', salary: '99', 
                       company: 'Acme', level: 'Junior', place: 'Remote Job',
                       date: 1.month.from_now)
    user1 = User.create!(:email => 'user1@test.com', :password => 'test123')
    user2 = User.create!(:email => 'user2@test.com', :password => 'test123')
    apply1 = Apply.create!(:job => job, :user => user1)
    apply2 = Apply.create!(:job => job, :user => user2)
    headhunter = Headhunter.create!(:email => 'admin@test.com', :password => 'test123')
    login_as(headhunter, :scope => :headhunter)
    
    visit root_path
    within('nav') do
      click_on I18n.t('openings')
    end
    expect(page).to have_link('Job Opening Test 123', href: job_path(1))
    click_on 'Job Opening Test 123'
    
    expect(page).to have_content(I18n.t('all_applies'))
    expect(page).to have_content('1')
    expect(page).to have_content('2') 
    expect(page).to have_content('user1@test.com')
    expect(page).to have_content('user2@test.com')
  end

  it 'without sucess' do
    job1 = Job.create!(title: 'Job Opening Test', description: 'Lorem ipsum dolor sit amet', 
                       skills: 'Nam mattis, felis ut adipiscing.', salary: '89',
                       company: 'Acme', level: 'Junior', place: 'Remote Job',
                       date: 1.month.from_now)
    job2 = Job.create!(title: 'Other Job Opening', description: 'Lorem ipsum dolor sit amet', 
                        skills: 'Nam mattis, felis ut adipiscing.', salary: '999', 
                        company: 'Acme', level: 'Junior', place: 'Remote Job',
                        date: 1.month.from_now)
    user1 = User.create!(:email => 'user1@test.com', :password => 'test123')
    user2 = User.create!(:email => 'user2@test.com', :password => 'test123')
    headhunter = Headhunter.create!(:email => 'admin@test.com', :password => 'test123')
    login_as(headhunter, :scope => :headhunter)
    
    visit root_path
    click_on I18n.t('openings')
    expect(page).to have_link('Job Opening Test', href: job_path(1))
    expect(page).to have_link('Other Job Opening', href: job_path(2))
    click_on 'Other Job Opening'    

    expect(page).not_to have_content(I18n.t('all_applies')) 
    expect(page).not_to have_content('user1@test.com ')
    expect(page).not_to have_content('user2@test.com ')
  end
end
