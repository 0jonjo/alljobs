require 'rails_helper'

describe 'User apllies to a job opening' do
  it 'with sucess' do
    Job.create!(title: 'Job Opening Test 123', description: 'Lorem ipsum dolor sit amet', 
                skills: 'Nam mattis, felis ut adipiscing.', salary: '99', 
                company: 'Acme', level: 'Junior', place: 'Remote Job',
                date: 1.month.from_now)
    user = User.create!(:email => 'user@test.com', :password => 'test123')
    profile = Profile.create!(name: 'Just a test', social_name: 'Just a test 2', 
                              birthdate: '21/03/1977', educacional_background: "Test 3", 
                              experience: 'test 4', user_id: user.id)
    login_as(user, :scope => :user)
    
    visit root_path
    within('nav') do
      click_on I18n.t('openings')
    end  
    expect(page).to have_content('Job Opening Test 123')
    click_on 'Job Opening Test 123'
    
    click_on I18n.t('apply')
    expect(page).to have_content('user@test.com')
    expect(page).to have_content('Job Opening Test 123')
  end

  it 'without sucess' do
    job = Job.create!(title: 'Job Opening Test 123', description: 'Lorem ipsum dolor sit amet', 
                  skills: 'Nam mattis, felis ut adipiscing.', salary: '99', 
                  company: 'Acme', level: 'Junior', place: 'Remote Job',
                  date: 1.month.from_now)
    user = User.create!(:email => 'user@test.com', :password => 'test123')
    profile = Profile.create!(name: 'Just a test', social_name: 'Just a test 2', 
                                birthdate: '21/03/1977', educacional_background: "Test 3", 
                                experience: 'test 4', user_id: user.id)
    apply = Apply.create!(:job => job, :user => user)
    login_as(user, :scope => :user)

    visit root_path
    click_on I18n.t('openings')
    click_on 'Job Opening Test 123'
    click_on I18n.t('apply')
    expect(current_path).to eq(job_path(apply.job_id))
  end  

  it "remove the apply" do
    job = Job.create!(title: 'Job Opening Test 123', description: 'Lorem ipsum dolor sit amet', 
    skills: 'Nam mattis, felis ut adipiscing.', salary: '99', 
    company: 'Acme', level: 'Junior', place: 'Remote Job',
    date: 1.month.from_now)
    user = User.create!(:email => 'user@test.com', :password => 'test123')
    profile = Profile.create!(name: 'Just a test', social_name: 'Just a test 2', 
                              birthdate: '21/03/1977', educacional_background: "Test 3", 
                              experience: 'test 4', user_id: user.id)
    apply = Apply.create!(:job => job, :user => user)
    login_as(user, :scope => :user)

    visit apply_path(apply)
    click_on I18n.t('delete')
    expect(current_path).to eq(root_path)
  end  
end