require 'rails_helper'

describe "Headhunter edit a proposal to a cadindidate" do 
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
    click_on "Edit"

    fill_in 'Salário', with: '66'
    fill_in 'Benefícios', with: 'add other benefits'
    fill_in 'Expectativas', with: 'add other expectations'
    fill_in 'Expectativa de Início', with: '01/01/2099'
    click_on 'Atualizar Proposta'

    expect(page).to have_content("You successfully edited this proposal.")
    expect(current_path).to eq(apply_path(apply))
  end

  it "without sucess - incomplete informations" do
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
    click_on "Edit"

    fill_in 'Salário', with: ''
    fill_in 'Benefícios', with: ''
    fill_in 'Expectativas', with: ''
    fill_in 'Expectativa de Início', with: ''
    click_on 'Atualizar Proposta'

    expect(page).to have_content("You do not edit this proposal.")
    expect(current_path).to eq(edit_apply_proposal_path(apply, proposal))
  end
end

describe "Headhunter delete a proposal to a cadindidate" do 
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
    click_on "Delete"

    expect(page).to have_content("You removed the proposal from the apply")
    expect(current_path).to eq(apply_path(apply))
  end
end  
