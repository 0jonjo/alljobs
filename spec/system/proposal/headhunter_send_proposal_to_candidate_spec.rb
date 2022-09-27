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

    visit apply_proposal_path(apply, proposal)

    expect(page).to have_content('Proposal 1')
    expect(page).to have_content('999')
    expect(page).to have_content('some benefits')
    expect(page).to have_content('some expectations')
    expect(page).to have_link('Apply ID 1', href: apply_path(1))
  end
end

describe "Headhunter create a proposal to a candidate" do 
  it "with sucess" do
    job = Job.create!(title: 'Job Opening Test', description: 'Lorem ipsum', 
                        skills: 'Nam mattis', salary: '99',
                        company: 'Acme', level: 'Junior', place: 'Remote Job',
                        date: 1.month.from_now)
    user = User.create!(:email => 'user@test.com', :password => 'test123')  
    headhunter = Headhunter.create!(:email => 'admin@test.com', :password => 'test123')
    apply = Apply.create!(:job => job, :user => user)   
    login_as(headhunter, :scope => :headhunter)
    
    visit apply_path(apply)
    click_on 'Make A Proposal'
    expect(current_path).to eq(new_apply_proposal_path(apply))
    
    fill_in 'Salary', with: '999'
    fill_in 'Benefits', with: 'some benefits'
    fill_in 'Expectations', with: 'some expectations'
    fill_in 'Expected start', with: '31/12/2099'
    click_on 'Create Proposal'
    
    expect(page).to have_content("You successfully create a proposal for this apply.")
    expect(current_path).to eq(apply_path(apply))
  end

  it "without sucess - already have a proposal" do
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
    
    visit apply_path(apply)
    click_on 'Make A Proposal'
  
    expect(page).to have_content("There is already a proposal for this apply.")
    expect(current_path).to eq(apply_path(apply))
  end

  it "without sucess - imcomplete" do
    job = Job.create!(title: 'Job Opening Test', description: 'Lorem ipsum', 
                        skills: 'Nam mattis', salary: '99',
                        company: 'Acme', level: 'Junior', place: 'Remote Job',
                        date: 1.month.from_now)
    user = User.create!(:email => 'user@test.com', :password => 'test123')  
    headhunter = Headhunter.create!(:email => 'admin@test.com', :password => 'test123')
    apply = Apply.create!(:job => job, :user => user)   
    login_as(headhunter, :scope => :headhunter)
    
    visit apply_path(apply)
    click_on 'Make A Proposal'
    expect(current_path).to eq(new_apply_proposal_path(apply))
    
    fill_in 'Salary', with: ''
    fill_in 'Benefits', with: ''
    fill_in 'Expectations', with: ''
    fill_in 'Expected start', with: ''
    click_on 'Create Proposal'
    
    expect(page).to have_content("You can't create a proposal for this apply.")
    expect(current_path).to eq(new_apply_proposal_path(apply))
  end
end