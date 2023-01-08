require 'rails_helper'

describe "Headhunter see a proposal to a cadindidate" do 
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

    expect(page).to have_content("#{Proposal.model_name.human} 1")
    expect(page).to have_content('999')
    expect(page).to have_content('some benefits')
    expect(page).to have_content('some expectations')
    expect(page).to have_link("#{Apply.human_attribute_name(:id)}: 1", href: apply_path(1))
  end
end

describe "Headhunter create a proposal to a candidate" do 
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
    login_as(headhunter, :scope => :headhunter)
    
    visit apply_path(apply)
    click_on I18n.t('send_proposal')
    expect(current_path).to eq(new_apply_proposal_path(apply))
    
    fill_in Proposal.human_attribute_name(:salary), with: '66'
    fill_in Proposal.human_attribute_name(:benefits), with: 'add other benefits'
    fill_in Proposal.human_attribute_name(:expectations), with: 'add other expectations'
    fill_in Proposal.human_attribute_name(:expected_start), with: '01/01/2099'
    click_on 'Criar Proposta'
    
    expect(page).to have_content("You successfully create a proposal for this apply.")
    expect(current_path).to eq(apply_path(apply))
  end

  it "without sucess - already have a proposal" do
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
    
    visit apply_path(apply)
  
    expect(page).not_to have_link(I18n.t('send_proposal'))
  end

  it "without sucess - imcomplete" do
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
    login_as(headhunter, :scope => :headhunter)
    
    visit apply_path(apply)
    click_on I18n.t('send_proposal')
    expect(current_path).to eq(new_apply_proposal_path(apply))
    
    fill_in Proposal.human_attribute_name(:salary), with: ''
    fill_in Proposal.human_attribute_name(:benefits), with: ''
    fill_in Proposal.human_attribute_name(:expectations), with: ''
    fill_in Proposal.human_attribute_name(:expected_start), with: ''
    click_on 'Criar Proposta'
    
    expect(page).to have_content("You can't create a proposal for this apply.")
    expect(current_path).to eq(new_apply_proposal_path(apply))
  end

  it "without sucess - recused apply" do
    job = Job.create!(title: 'Job Opening Test', description: 'Lorem ipsum', 
                        skills: 'Nam mattis', salary: '99',
                        company: 'Acme', level: 'Junior', place: 'Remote Job',
                        date: 1.month.from_now)
    user = User.create!(:email => 'user@test.com', :password => 'test123')  
    profile = Profile.create!(name: 'Just a test', social_name: 'Just a test 2', 
                              birthdate: '21/03/1977', educacional_background: "Test 3", 
                              experience: 'test 4', user_id: user.id)
    headhunter = Headhunter.create!(:email => 'admin@test.com', :password => 'test123')
    apply = Apply.create!(:job => job, :user => user, :accepted_headhunter => false)   
    login_as(headhunter, :scope => :headhunter)

    visit apply_path(apply)
    click_on I18n.t('send_proposal')
    expect(current_path).to eq(new_apply_proposal_path(apply))
    
    fill_in Proposal.human_attribute_name(:salary), with: '9999'
    fill_in Proposal.human_attribute_name(:benefits), with: 'test'
    fill_in Proposal.human_attribute_name(:expectations), with: 'test'
    fill_in Proposal.human_attribute_name(:expected_start), with: 1.month.from_now
    click_on 'Criar Proposta'
    
    expect(page).to have_content("You can't create a proposal to a rejected apply.")
    expect(current_path).to eq(new_apply_proposal_path(apply))
  end
end