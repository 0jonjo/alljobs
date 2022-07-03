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
      fill_in 'Date', with: '21/11/2099'
      click_on 'Update Job'
    
      expect(page).to have_content 'Job Opening Test 123'
      expect(page).to have_content '9999'
      expect(page).to have_content 'Junior'
    end

    it 'without sucess' do
      job1 = Job.create!(title: 'Job Opening Test', description: 'Lorem ipsum dolor sit amet', 
                          skills: 'Nam mattis, felis ut adipiscing.', salary: '99',
                          company: 'Acme', level: 'Junior', place: 'Remote Job',
                          date: 1.month.from_now)
      headhunter = Headhunter.create!(:email => 'admin@test.com', :password => 'test123')
      login_as(headhunter, :scope => :headhunter)
      visit root_path
      
      click_on 'Openings'
      click_on 'Job Opening Test'
      click_on 'Edit'

      expect(current_path).to eq edit_job_path(1)
      fill_in 'Title', with: ''
      fill_in 'Description', with: ''
      fill_in 'Skills', with: ''
      fill_in 'Salary', with: ''
      fill_in 'Level', with: ''
      fill_in 'Place', with: ''
      fill_in 'Date', with: ''
      click_on 'Update Job'
    
      expect(page).to have_content "Job Opening was not edited."
      expect(page).to have_content("Title can't be blank")
      expect(page).to have_content("Skills can't be blank")
      expect(page).to have_content("Salary can't be blank")
      expect(current_path).to eq job_path(1)
    end
end
