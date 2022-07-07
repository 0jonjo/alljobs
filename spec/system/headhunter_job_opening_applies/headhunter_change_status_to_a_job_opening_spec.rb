require 'rails_helper'

describe 'Headhunter change status to a job opening' do
    it 'with sucess - draft' do
      job = Job.create!(title: 'Job Opening Test', description: 'Lorem ipsum dolor sit amet', 
                          skills: 'Nam mattis, felis ut adipiscing.', salary: '99',
                          company: 'Acme', level: 'Junior', place: 'Remote Job',
                          date: 1.month.from_now, job_status: :published)
      headhunter = Headhunter.create!(:email => 'admin@test.com', :password => 'test123')
      login_as(headhunter, :scope => :headhunter)
      visit root_path
      
      click_on 'Openings'
      click_on job.title
      click_on 'Change to Draft'

      expect(current_path).to eq job_path(job.id)
    
      expect(page).to have_content 'Status Draft'
      expect(page).not_to have_content 'Published'
    end

    it 'with sucess - archived' do
      job = Job.create!(title: 'Job Opening Test', description: 'Lorem ipsum dolor sit amet', 
                          skills: 'Nam mattis, felis ut adipiscing.', salary: '99',
                          company: 'Acme', level: 'Junior', place: 'Remote Job',
                          date: 1.month.from_now, job_status: :published)
      headhunter = Headhunter.create!(:email => 'admin@test.com', :password => 'test123')
      login_as(headhunter, :scope => :headhunter)
      visit root_path
      
      click_on 'Openings'
      click_on job.title
      expect(page).not_to have_button 'Change to Published'
      click_on 'Change to Archived'

      expect(current_path).to eq job_path(job.id)
    
      expect(page).to have_content 'Status Archived'
      expect(page).not_to have_content 'Published'
    end

    it 'without sucess - have not button published' do
      job = Job.create!(title: 'Job Opening Test', description: 'Lorem ipsum dolor sit amet', 
                          skills: 'Nam mattis, felis ut adipiscing.', salary: '99',
                          company: 'Acme', level: 'Junior', place: 'Remote Job',
                          date: 1.month.from_now, job_status: :published)
      headhunter = Headhunter.create!(:email => 'admin@test.com', :password => 'test123')
      login_as(headhunter, :scope => :headhunter)
      visit root_path
      
      click_on 'Openings'
      click_on job.title
  
      expect(page).to have_content 'Status Published'
      expect(page).not_to have_button 'Change to Published'
      expect(page).to have_button 'Change to Draft'
      expect(page).to have_button 'Change to Archived'
    end
end
