require 'rails_helper'

describe 'User applied to job opening' do
  it 'and cant see the apply because without login' do
    job = Job.create!(title: 'Job Opening Test 123', description: 'Lorem ipsum dolor sit amet', 
                      skills: 'Nam mattis, felis ut adipiscing.', salary: '99', 
                      company: 'Acme', level: 'Junior', place: 'Remote Job',
                      date: 1.month.from_now)
    user = User.create!(:email => 'user@test.com', :password => 'test123')
    user2 = User.create!(:email => 'user2@test.com', :password => 'test123')
    apply = Apply.create!(:job => job, :user => user)
    apply2 = Apply.create!(:job => job, :user => user2)
    login_as(user, :scope => :user)

    visit apply_path(apply)
  end
    
  it 'and see only your apply' do
    job = Job.create!(title: 'Job Opening Test 123', description: 'Lorem ipsum dolor sit amet', 
                      skills: 'Nam mattis, felis ut adipiscing.', salary: '99', 
                      company: 'Acme', level: 'Junior', place: 'Remote Job',
                      date: 1.month.from_now)
    user = User.create!(:email => 'user@test.com', :password => 'test123')
    user2 = User.create!(:email => 'user2@test.com', :password => 'test123')
    apply = Apply.create!(:job => job, :user => user)
    apply2 = Apply.create!(:job => job, :user => user2)
    login_as(user, :scope => :user)

    visit apply_path(apply)
    expect(page).to have_content('user@test.com')
    expect(page).not_to have_content('user2@test.com')
    expect(page).to have_content('Job Opening Test 123')
    expect(page).to have_content('Apply ID')
    expect(page).to have_content('User ID')
    expect(page).to have_content('User Email')
  end

  it "and see only his multiply applies" do
    job1 = Job.create!(title: 'Job Opening Test', description: 'Lorem ipsum dolor sit amet', 
                      skills: 'Nam mattis, felis ut adipiscing.', salary: '99', 
                      company: 'Acme', level: 'Junior', place: 'Remote Job',
                      date: 1.month.from_now)
    job2 = Job.create!(title: 'Other Job Opening', description: 'Lorem ipsum dolor sit amet', 
                      skills: 'Test.', salary: '999', 
                      company: 'Acme', level: 'Junior', place: 'Remote Job',
                      date: 1.month.from_now)
    user = User.create!(:email => 'user@test.com', :password => 'test123')
    user2 = User.create!(:email => 'user2@test.com', :password => 'test123')
    apply1 = Apply.create!(:job => job1, :user => user)
    apply2 = Apply.create!(:job => job2, :user => user)
    apply3 = Apply.create!(:job => job2, :user => user2)
    login_as(user, :scope => :user)

    visit applies_path
    expect(page).to have_content('Job Opening Test')
    expect(page).to have_content('Other Job Opening')
    expect(page).to have_content('Apply ID')
    expect(page).not_to have_content('3')
  end
end