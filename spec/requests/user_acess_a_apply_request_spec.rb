require 'rails_helper'

describe "User try to acess a apply" do
  it "and are not his apply" do
    user = User.create!(:email => 'user@test.com', :password => 'test123')
    user2 = User.create!(:email => 'user2@test.com', :password => 'test123')
    profile = Profile.create!(name: 'Just a test', social_name: 'Just a test 2', birthdate: '21/03/1977',
                                educacional_background: "Test 3", experience: 'test 4', 
                                user_id: user.id)
    job = Job.create!(title: 'Job Opening Test 123', description: 'Lorem ipsum dolor sit amet', 
                      skills: 'Nam mattis, felis ut adipiscing.', salary: '99', 
                      company: 'Acme', level: 'Junior', place: 'Remote Job',
                      date: 1.month.from_now)
    apply = Apply.create!(:job => job, :user => user)                   

    login_as(user2, :scope => :user)
    get(apply_path(apply))
    expect(response).to redirect_to(new_profile_path)
  end  
end    
