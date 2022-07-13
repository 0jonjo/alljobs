require 'rails_helper'

describe "Headhunter see a proposal to a cadindidate" do 
  it "with sucess" do
    job = Job.create!(title: 'Job Opening Test', description: 'Lorem ipsum', 
                        skills: 'Nam mattis', salary: '99',
                        company: 'Acme', level: 'Junior', place: 'Remote Job',
                        date: 1.month.from_now)
    user = User.create!(:email => 'user@test.com', :password => 'test123')  
    headhunter = Headhunter.create!(:email => 'admin@test.com', :password => 'test123')
    apply = Apply.create!(:job => job, :user => user)   
    proposal = Proposal.create!(apply: apply, salary: 999, benefits: "some benefits", 
                                  expectations: "some expectations", expected_start: 1.month.from_now)
    login_as(headhunter, :scope => :headhunter)

    visit proposal_path(proposal)

    expect(page).to have_content('Proposal')
    expect(page).to have_content('999')
    expect(page).to have_content('some benefits')
    expect(page).to have_content('some expectations')
    expect(page).to have_link('1', href: apply_path(1))
  end
end

describe "Headhunter send proposal to a cadindidate" do 
  it "with sucess" do
    job = Job.create!(title: 'Job Opening Test', description: 'Lorem ipsum', 
                        skills: 'Nam mattis', salary: '99',
                        company: 'Acme', level: 'Junior', place: 'Remote Job',
                        date: 1.month.from_now)
    user = User.create!(:email => 'user@test.com', :password => 'test123')  
    headhunter = Headhunter.create!(:email => 'admin@test.com', :password => 'test123')
    apply = Apply.create!(:job => job, :user => user)   
    #proposal = Proposal.create!(apply: apply)
    login_as(headhunter, :scope => :headhunter)
  end
end