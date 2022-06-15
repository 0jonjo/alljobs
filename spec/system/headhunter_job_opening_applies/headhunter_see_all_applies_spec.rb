require 'rails_helper'

describe 'Headhunter sees all applies' do
  it 'with sucess' do
   job1 = Job.create!(title: 'Job Opening Test', description: 'Lorem ipsum dolor sit amet', 
                       skills: 'Nam mattis, felis ut adipiscing.', salary: '99',
                       company: 'Acme', level: 'Junior', place: 'Remote Job',
                       date: 24/12/2099)
    job2 = Job.create!(title: 'Other Job Opening', description: 'Lorem ipsum dolor sit amet', 
                        skills: 'Nam mattis, felis ut adipiscing.', salary: '109', 
                        company: 'Acme', level: 'Junior', place: 'Remote Job',
                        date: 24/12/2099)
    user1 = User.create!(:email => 'user1@test.com', :password => 'test123')
    user2 = User.create!(:email => 'user2@test.com', :password => 'test123')
    user_that_not_apply = User.create!(:email => 'user3@test.com', :password => 'test123')
    headhunter = Headhunter.create!(:email => 'admin@test.com', :password => 'test123')
    login_as(headhunter, :scope => :headhunter)
    apply1 = Apply.create!(:job => job1, :user => user1)
    apply2 = Apply.create!(:job => job2, :user => user2)
    visit root_path

    within('nav') do
      click_on 'Applies'
    end

    expect(page).to have_content('Applies')
    expect(page).to have_link('Job Opening Test', href: apply_path(1))
    expect(page).to have_link('Other Job Opening', href: apply_path(2))
    expect(page).to have_content('1')
    expect(page).to have_content('2')
    expect(page).to have_content('user1@test.com')
    expect(page).to have_content('user2@test.com')
    expect(page).not_to have_content('3')
    expect(page).not_to have_content('user3@test.com')
  end

  it 'without any apply' do
    headhunter = Headhunter.create!(:email => 'admin@test.com', :password => 'test123')
    login_as(headhunter, :scope => :headhunter)

    visit root_path
    within('nav') do
      click_on 'Applies'
    end
    
    expect(page).to have_content("There aren't any apply.")
  end
end
