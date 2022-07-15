require 'rails_helper'

describe "User try to acess a proposal" do
  it "and are not his proposal" do
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
    proposal = Proposal.create!(apply: apply, salary: 999, benefits: "some benefits", 
                                expectations: "some expectations", 
                                expected_start: 1.month.from_now)                 
    login_as(user2, :scope => :user)
    get(apply_proposal_path(apply, proposal))
    expect(response).to redirect_to(root_path)
  end  
end    
