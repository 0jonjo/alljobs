require 'rails_helper'

describe 'User rejected to an apply' do
  it "and see feedback with sucess" do
    user = User.create!(:email => 'user@test.com', :password => 'test123')
    profile = Profile.create!(name: 'Just a test', social_name: 'Just a test 2', 
                              birthdate: '21/03/1977', educacional_background: "Test 3", 
                              experience: 'test 4', user_id: user.id)
    job =  Job.create!(title: 'Job Opening Test', description: 'Lorem ipsum dolor sit amet', 
                    skills: 'Nam mattis, felis ut adipiscing.', salary: '99',
                    company: 'Acme', level: 'Junior', place: 'Remote',
                    date: 1.month.from_now)
    apply = Apply.create!(:job => job, :user => user, :accepted_headhunter => false, :feedback_headhunter => "Test feedback")             
    headhunter = Headhunter.create!(:email => 'admin@test.com', :password => 'test123')
    login_as(user, :scope => :user)
    visit apply_path(apply)

    expect(page).to have_content("Test feedback")
  end
  
  it "and see feedback without sucess - not his apply" do
    user1 = User.create!(:email => 'user@test.com', :password => 'test123')
    user2 = User.create!(:email => 'user2@test.com', :password => 'test123')
    profile2 = Profile.create!(name: 'Just a test', social_name: 'Just a test 2', 
                                birthdate: '21/03/1977', educacional_background: "Test 3", 
                                experience: 'test 4', user_id: user2.id)
    job =  Job.create!(title: 'Job Opening Test', description: 'Lorem ipsum dolor sit amet', 
                    skills: 'Nam mattis, felis ut adipiscing.', salary: '99',
                    company: 'Acme', level: 'Junior', place: 'Remote',
                    date: 1.month.from_now)
    apply = Apply.create!(:job => job, :user => user1, :accepted_headhunter => false, :feedback_headhunter => "Test feedback")             
    headhunter = Headhunter.create!(:email => 'admin@test.com', :password => 'test123')
    login_as(user2, :scope => :user)
    visit apply_path(apply)
    
    expect(current_path).to eq(root_path)
    expect(page).not_to have_content("Test feedback")
  end  
end

