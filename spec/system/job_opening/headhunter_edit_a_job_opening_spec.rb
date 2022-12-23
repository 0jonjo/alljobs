require 'rails_helper'

describe 'Headhunter edit a job opening' do
    it 'with sucess' do
      job1 = Job.create!(title: 'Job Opening Test', description: 'Lorem ipsum dolor sit amet', 
                          skills: 'Nam mattis, felis ut adipiscing.', salary: '99',
                          company: 'Acme', level: 'Junior', place: 'Remote Job',
                          date: 1.month.from_now, job_status: :published)
      headhunter = Headhunter.create!(:email => 'admin@test.com', :password => 'test123')
      login_as(headhunter, :scope => :headhunter)
      visit root_path
      
      click_on I18n.t('openings')
      click_on 'Job Opening Test'
      click_on I18n.t('edit')

      expect(current_path).to eq edit_job_path(1)
      fill_in Job.human_attribute_name(:title), with: 'Job Opening Test 123'
      fill_in Job.human_attribute_name(:description), with: 'Lorem ipsum dolor '
      fill_in Job.human_attribute_name(:skills), with: 'Lorem ipsuctus'
      fill_in Job.human_attribute_name(:salary), with: '9999'
      fill_in Job.human_attribute_name(:level), with: 'Junior'
      fill_in Job.human_attribute_name(:place), with: 'Remote Job'
      fill_in Job.human_attribute_name(:date), with: 1.month.from_now
      click_on 'Atualizar Vaga'
    
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
      
      click_on I18n.t('openings')
      click_on 'Job Opening Test'
      click_on I18n.t('edit')

      expect(current_path).to eq edit_job_path(1)
      fill_in Job.human_attribute_name(:title), with: ''
      fill_in Job.human_attribute_name(:description), with: ''
      fill_in Job.human_attribute_name(:skills), with: ''
      fill_in Job.human_attribute_name(:salary), with: ''
      fill_in Job.human_attribute_name(:company), with: ''
      fill_in Job.human_attribute_name(:level), with: ''
      fill_in Job.human_attribute_name(:place), with: ''
      fill_in Job.human_attribute_name(:date), with: ''
      click_on 'Atualizar Vaga'
    
      expect(page).to have_content("Título não pode ficar em branco")
      expect(page).to have_content("Habilidades não pode ficar em branco")
      expect(page).to have_content("Salário não pode ficar em branco")
      expect(current_path).to eq job_path(1)
    end
end
