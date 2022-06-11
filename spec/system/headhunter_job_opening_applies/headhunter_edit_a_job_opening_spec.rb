require 'rails_helper'

describe 'Headhunter edit a job opening' do
    it 'with sucess' do
      job1 = Job.create!(title: 'Job Opening Test', description: 'Lorem ipsum dolor sit amet', 
                          skills: 'Nam mattis, felis ut adipiscing.', salary: '99',
                          company: 'Acme', level: 'Junior', place: 'Remote Job',
                          date: '24/12/2099')
      headhunter = Headhunter.create!(:email => 'admin@test.com', :password => 'test123')
      login_as(headhunter, :scope => :headhunter)
      visit root_path
      
      click_on 'Openings'
      click_on 'Job Opening Test'
      click_on 'Edit'

      expect(current_path).to eq edit_job_path(1)
      fill_in 'Title', with: 'Job Opening Test 123'
      fill_in 'Description', with: 'Lorem ipsum dolor '
      fill_in 'Skills', with: 'Lorem ipsuctus'
      fill_in 'Salary', with: '9999'
      fill_in 'Level', with: 'Junior'
      fill_in 'Place', with: 'Remote Job'
      fill_in 'Date', with: '21/11/2022'
      click_on 'Update Job'
    
      expect(page).to have_content 'Job Opening Test 123'
      expect(page).to have_content '9999'
      expect(page).to have_content 'Junior'
    end
end
