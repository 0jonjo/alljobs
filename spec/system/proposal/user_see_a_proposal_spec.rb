require 'rails_helper'

describe "User see a proposal to a cadindidate" do 
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

    visit apply_proposal_path(apply, proposal)

    expect(page).to have_content("#{Proposal.model_name.human} 1")
    expect(page).to have_content('999')
    expect(page).to have_content('some benefits')
    expect(page).to have_content('some expectations')
    expect(page).to have_link("#{Apply.human_attribute_name(:id)} 1", href: apply_path(1))
  end

  it "without sucess - not a proposal to him" do
    job = Job.create!(title: 'Job Opening Test', description: 'Lorem ipsum', 
                        skills: 'Nam mattis', salary: '99',
                        company: 'Acme', level: 'Junior', place: 'Remote Job',
                        date: 1.month.from_now)
    user = User.create!(:email => 'user@test.com', :password => 'test123')  
    user2 = User.create!(:email => 'user2@test.com', :password => 'test123')
    apply = Apply.create!(:job => job, :user => user)   
    proposal = Proposal.create!(apply: apply, salary: 999, benefits: "some benefits", 
                                  expectations: "some expectations", expected_start: 1.month.from_now)
    login_as(user2, :scope => :user)

    visit apply_proposal_path(apply, proposal)

    expect(page).to have_content('You do not have access to this proposal.')
    expect(current_path).to eq(root_path)
  end
end

