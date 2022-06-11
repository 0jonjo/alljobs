require 'rails_helper'

describe 'User apllies to a job opening' do
  it 'with sucess' do
    Job.create!(title: 'Job Opening Test 123', description: 'Lorem ipsum dolor sit amet', 
                skills: 'Nam mattis, felis ut adipiscing.', salary: '99', 
                company: 'Acme', level: 'Junior', place: 'Remote Job',
                date: 24/12/2099)
    user = User.create!(:email => 'user@test.com', :password => 'test123')
    login_as(user, :scope => :user)
    
    visit root_path
    within('nav') do
      click_on 'Openings'
    end  
    expect(page).to have_content('Job Opening Test 123')
    click_on 'Job Opening Test 123'
    
    click_on 'Apply for this Job'
    expect(page).to have_content('User Email: user@test.com')
    expect(page).to have_content('Job Opening Test 123')
  end
end