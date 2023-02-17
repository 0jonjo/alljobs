require 'rails_helper'

describe 'Headhunter rejects an apply' do
  it 'with sucess' do
    user = User.create!(:email => 'user@test.com', :password => 'test123')
    profile = Profile.create!(name: 'Just a test', social_name: 'Just a test 2', 
                              birthdate: '21/03/1977', educacional_background: "Test 3", 
                              experience: 'test 4', user_id: user.id)
    job =  Job.create!(title: 'Job Opening Test', description: 'Lorem ipsum dolor sit amet', 
                    skills: 'Nam mattis, felis ut adipiscing.', salary: '99',
                    company: 'Acme', level: 'Junior', place: 'Remote',
                    date: 1.month.from_now)
    apply = Apply.create!(:job => job, :user => user)             
    headhunter = Headhunter.create!(:email => 'admin@test.com', :password => 'test123')
    login_as(headhunter, :scope => :headhunter)
    visit apply_path(apply)

    click_on I18n.t('feedback')
    fill_in Apply.human_attribute_name(:feedback_headhunter), with: "You need more experience to this job."
    click_on "Atualizar Inscrição"
    
    expect(current_path).to eq(apply_path(apply))
    expect(page).to have_content("You need more experience to this job.")
  end
  
  it "and edit with sucess" do
    user = User.create!(:email => 'user@test.com', :password => 'test123')
    profile = Profile.create!(name: 'Just a test', social_name: 'Just a test 2', 
                              birthdate: '21/03/1977', educacional_background: "Test 3", 
                              experience: 'test 4', user_id: user.id)
    job =  Job.create!(title: 'Job Opening Test', description: 'Lorem ipsum dolor sit amet', 
                    skills: 'Nam mattis, felis ut adipiscing.', salary: '99',
                    company: 'Acme', level: 'Junior', place: 'Remote',
                    date: 1.month.from_now)
    apply = Apply.create!(:job => job, :user => user, :accepted_headhunter => false, :feedback_headhunter => "test")             
    headhunter = Headhunter.create!(:email => 'admin@test.com', :password => 'test123')
    login_as(headhunter, :scope => :headhunter)
    visit apply_path(apply)

    click_on I18n.t('feedback')
    fill_in Apply.human_attribute_name(:feedback_headhunter), with: "Test edit feedback."
    click_on "Atualizar Inscrição"
    
    expect(current_path).to eq(apply_path(apply))
    expect(page).to have_content("Test edit feedback.")
  end  
end

