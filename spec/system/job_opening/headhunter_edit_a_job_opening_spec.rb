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
      
      click_on 'Openings'
      click_on 'Job Opening Test'
      click_on 'Edit'

      expect(current_path).to eq edit_job_path(1)
      fill_in 'Título', with: 'Job Opening Test 123'
      fill_in 'Descrição', with: 'Lorem ipsum dolor '
      fill_in 'Habilidades', with: 'Lorem ipsuctus'
      fill_in 'Salário', with: '9999'
      fill_in 'Nível', with: 'Junior'
      fill_in 'Lugar', with: 'Remote Job'
      fill_in 'Data', with: '21/11/2099'
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
      
      click_on 'Openings'
      click_on 'Job Opening Test'
      click_on 'Edit'

      expect(current_path).to eq edit_job_path(1)
      fill_in 'Título', with: ''
      fill_in 'Descrição', with: ''
      fill_in 'Habilidades', with: ''
      fill_in 'Salário', with: ''
      fill_in 'Nível', with: ''
      fill_in 'Lugar', with: ''
      fill_in 'Data', with: ''
      click_on 'Atualizar Vaga'
    
      expect(page).to have_content "Job Opening was not edited."
      expect(page).to have_content("Título não pode ficar em branco")
      expect(page).to have_content("Habilidades não pode ficar em branco")
      expect(page).to have_content("Salário não pode ficar em branco")
      expect(current_path).to eq job_path(1)
    end
end
