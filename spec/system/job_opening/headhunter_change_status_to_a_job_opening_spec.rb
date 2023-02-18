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

      click_on I18n.t('openings')
      click_on job.title
      click_on I18n.t('draft')

      expect(current_path).to eq job_path(job.id)

      expect(page).to have_content(Job.human_attribute_name(:job_status))
      expect(page).to have_content('draft')
    end

    it 'with sucess - archived' do
      job = Job.create!(title: 'Job Opening Test', description: 'Lorem ipsum dolor sit amet', 
                          skills: 'Nam mattis, felis ut adipiscing.', salary: '99',
                          company: 'Acme', level: 'Junior', place: 'Remote Job',
                          date: 1.month.from_now, job_status: :published)
      headhunter = Headhunter.create!(:email => 'admin@test.com', :password => 'test123')
      login_as(headhunter, :scope => :headhunter)
      visit root_path

      click_on I18n.t('openings')
      click_on job.title
      expect(page).not_to have_button I18n.t('published')
      click_on I18n.t('archived')

      expect(current_path).to eq job_path(job.id)

      expect(page).to have_content('archived')
      expect(page).not_to have_content('published')
    end

    it 'without sucess - have not button published' do
      job = Job.create!(title: 'Job Opening Test', description: 'Lorem ipsum dolor sit amet', 
                          skills: 'Nam mattis, felis ut adipiscing.', salary: '99',
                          company: 'Acme', level: 'Junior', place: 'Remote Job',
                          date: 1.month.from_now, job_status: :published)
      headhunter = Headhunter.create!(:email => 'admin@test.com', :password => 'test123')
      login_as(headhunter, :scope => :headhunter)
      visit root_path

      click_on I18n.t('openings')
      click_on job.title

      expect(page).to have_content('published')
      expect(page).not_to have_button(I18n.t('published'))
      expect(page).to have_button(I18n.t('draft'))
      expect(page).to have_button(I18n.t('archived'))
    end
end
