require 'rails_helper'

describe "Headhunter edit a proposal to a cadindidate" do 
  it "with sucess" do
    job = Job.create!(title: 'Job Opening Test', description: 'Lorem ipsum', 
                        skills: 'Nam mattis', salary: '99',
                        company: 'Acme', level: 'Junior', place: 'Remote Job',
                        date: 1.month.from_now)
    user = User.create!(:email => 'user@test.com', :password => 'test123')  
    profile = Profile.create!(name: 'Just a test', social_name: 'Just a test 2', 
                              birthdate: '21/03/1977', educacional_background: "Test 3", 
                              experience: 'test 4', user_id: user.id)
    headhunter = Headhunter.create!(:email => 'admin@test.com', :password => 'test123')
    apply = Apply.create!(:job => job, :user => user)   
    proposal = Proposal.create!(apply: apply, salary: 999, benefits: "some benefits", 
                                  expectations: "some expectations", expected_start: 1.month.from_now)
    login_as(headhunter, :scope => :headhunter)

    visit apply_proposal_path(apply, proposal)
    click_on I18n.t('edit')

    fill_in Proposal.human_attribute_name(:salary), with: '66'
    fill_in Proposal.human_attribute_name(:benefits), with: 'add other benefits'
    fill_in Proposal.human_attribute_name(:expectations), with: 'add other expectations'
    fill_in Proposal.human_attribute_name(:expected_start), with: '01/01/2099'
    click_on 'Atualizar Proposta'

    expect(page).to have_content("You successfully edited this proposal.")
    expect(current_path).to eq(apply_path(apply))
  end

  it "without sucess - rejected apply" do
    job = Job.create!(title: 'Job Opening Test', description: 'Lorem ipsum', 
                        skills: 'Nam mattis', salary: '99',
                        company: 'Acme', level: 'Junior', place: 'Remote Job',
                        date: 1.month.from_now)
    user = User.create!(:email => 'user@test.com', :password => 'test123')  
    profile = Profile.create!(name: 'Just a test', social_name: 'Just a test 2', 
                              birthdate: '21/03/1977', educacional_background: "Test 3", 
                              experience: 'test 4', user_id: user.id)    
    headhunter = Headhunter.create!(:email => 'admin@test.com', :password => 'test123')
    apply = Apply.create!(:job => job, :user => user)   
    proposal = Proposal.create!(apply: apply, salary: 999, benefits: "some benefits", 
                                  expectations: "some expectations", expected_start: 1.month.from_now)
    
                                  login_as(headhunter, :scope => :headhunter)
    apply.accepted_headhunter = false
    apply.save
    
    visit apply_proposal_path(apply, proposal)
    click_on I18n.t('edit')

    fill_in Proposal.human_attribute_name(:salary), with: '66'
    fill_in Proposal.human_attribute_name(:benefits), with: 'add other benefits'
    fill_in Proposal.human_attribute_name(:expectations), with: 'add other expectations'
    fill_in Proposal.human_attribute_name(:expected_start), with: 1.month.from_now
    click_on 'Atualizar Proposta'

    expect(page).to have_content("There is already a proposal for this apply.")
    expect(current_path).to eq(apply_path(apply))
  end

  it "without sucess - incomplete informations" do
    job = Job.create!(title: 'Job Opening Test', description: 'Lorem ipsum', 
                        skills: 'Nam mattis', salary: '99',
                        company: 'Acme', level: 'Junior', place: 'Remote Job',
                        date: 1.month.from_now)
    user = User.create!(:email => 'user@test.com', :password => 'test123')  
    profile = Profile.create!(name: 'Just a test', social_name: 'Just a test 2', 
                              birthdate: '21/03/1977', educacional_background: "Test 3", 
                              experience: 'test 4', user_id: user.id)
    headhunter = Headhunter.create!(:email => 'admin@test.com', :password => 'test123')
    apply = Apply.create!(:job => job, :user => user)   
    proposal = Proposal.create!(apply: apply, salary: 999, benefits: "some benefits", 
                                  expectations: "some expectations", expected_start: 1.month.from_now)
    login_as(headhunter, :scope => :headhunter)

    visit apply_proposal_path(apply, proposal)
    click_on I18n.t('edit')

    fill_in Proposal.human_attribute_name(:salary), with: ''
    fill_in Proposal.human_attribute_name(:benefits), with: ''
    fill_in Proposal.human_attribute_name(:expectations), with: ''
    fill_in Proposal.human_attribute_name(:expected_start), with: ''
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
    profile = Profile.create!(name: 'Just a test', social_name: 'Just a test 2', 
                              birthdate: '21/03/1977', educacional_background: "Test 3", 
                              experience: 'test 4', user_id: user.id)
    headhunter = Headhunter.create!(:email => 'admin@test.com', :password => 'test123')
    apply = Apply.create!(:job => job, :user => user)   
    proposal = Proposal.create!(apply: apply, salary: 999, benefits: "some benefits", 
                                  expectations: "some expectations", expected_start: 1.month.from_now)
    login_as(headhunter, :scope => :headhunter)

    visit apply_proposal_path(apply, proposal)
    click_on I18n.t('delete')

    expect(page).to have_content("You removed the proposal from the apply")
    expect(current_path).to eq(apply_path(apply))
  end
end  
