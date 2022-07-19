require 'rails_helper'

describe "User see a proposal on an apply" do 
  it "with sucess" do
    job = Job.create!(title: 'Job Opening Test', description: 'Lorem ipsum', 
                        skills: 'Nam mattis', salary: '99',
                        company: 'Acme', level: 'Junior', place: 'Remote Job',
                        date: 1.month.from_now)
    user = User.create!(:email => 'user@test.com', :password => 'test123')  
    apply = Apply.create!(:job => job, :user => user)   
    proposal = Proposal.create!(apply: apply, salary: 999, benefits: "some benefits", 
                                  expectations: "some expectations", expected_start: 1.month.from_now)
    login_as(user, :scope => :user)

    visit apply_path(apply)

    expect(page).to have_content('See Proposal 1')
    expect(page).to have_link('1', href: apply_proposal_path(apply, proposal))
  end
end

