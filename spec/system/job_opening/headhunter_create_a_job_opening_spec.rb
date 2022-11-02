require 'rails_helper'

describe 'Headhunter create a job opening' do
    it 'with sucess - status published' do
      headhunter = Headhunter.create!(:email => 'admin@test.com', :password => 'test123')
      login_as(headhunter, :scope => :headhunter)
      allow(SecureRandom).to receive(:alphanumeric).and_return('12345678')
      visit root_path
      
      within('nav') do
        click_on 'New Job Opening'
      end
      fill_in 'Título', with: 'Job Opening Test'
      fill_in 'Descrição', with: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eget ligula eu lectus lobortis condimentum. Aliquam nonummy auctor massa. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nulla at risus. Quisque purus magna, auctor et, sagittis ac, posuere eu, lectus. Nam mattis, felis ut adipiscing.'
      fill_in 'Habilidades', with: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eget ligula eu lectus lobortis condimentum. Aliquam nonummy auctor massa. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nulla at risus. Quisque purus magna, auctor et, sagittis ac, posuere eu, lectus. Nam mattis, felis ut adipiscing.'
      fill_in 'Salário', with: '9999'
      fill_in 'Empresa', with: 'Test'
      fill_in 'Nível', with: 'Junior'
      fill_in 'Lugar', with: 'Remote Job'
      fill_in 'Data', with: '21/11/2099'
      select 'published', from: 'Status da Vaga'
      click_on 'Criar Vaga'
  
      expect(current_path).to eq job_path(1)
      expect(page).to have_content("You successfully registered a Job Opening.")
      expect(page).to have_content("Job Opening Test")
      expect(page).to have_content("12345678")
      expect(page).to have_content("Test")
      expect(page).to have_content("Junior")
      expect(page).to have_content("21/11/2099")
      expect(page).to have_content("Published")
    end

    it 'with sucess - status archived' do
      headhunter = Headhunter.create!(:email => 'admin@test.com', :password => 'test123')
      login_as(headhunter, :scope => :headhunter)
      visit new_job_path
     
      fill_in 'Título', with: 'Job Opening Test'
      fill_in 'Descrição', with: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eget ligula eu lectus lobortis condimentum. Aliquam nonummy auctor massa. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nulla at risus. Quisque purus magna, auctor et, sagittis ac, posuere eu, lectus. Nam mattis, felis ut adipiscing.'
      fill_in 'Habilidades', with: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eget ligula eu lectus lobortis condimentum. Aliquam nonummy auctor massa. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nulla at risus. Quisque purus magna, auctor et, sagittis ac, posuere eu, lectus. Nam mattis, felis ut adipiscing.'
      fill_in 'Salário', with: '9999'
      fill_in 'Empresa', with: 'Test'
      fill_in 'Nível', with: 'Junior'
      fill_in 'Lugar', with: 'Remote Job'
      fill_in 'Data', with: '21/11/2099'
      select 'archived', from: 'Status da Vaga'
      click_on 'Criar Vaga'
  
      expect(current_path).to eq job_path(1)
      expect(page).to have_content("Archived")
    end

    it 'with sucess - status archived' do
      headhunter = Headhunter.create!(:email => 'admin@test.com', :password => 'test123')
      login_as(headhunter, :scope => :headhunter)
      visit new_job_path
     
      fill_in 'Título', with: 'Job Opening Test'
      fill_in 'Descrição', with: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eget ligula eu lectus lobortis condimentum. Aliquam nonummy auctor massa. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nulla at risus. Quisque purus magna, auctor et, sagittis ac, posuere eu, lectus. Nam mattis, felis ut adipiscing.'
      fill_in 'Habilidades', with: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eget ligula eu lectus lobortis condimentum. Aliquam nonummy auctor massa. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nulla at risus. Quisque purus magna, auctor et, sagittis ac, posuere eu, lectus. Nam mattis, felis ut adipiscing.'
      fill_in 'Salário', with: '9999'
      fill_in 'Empresa', with: 'Test'
      fill_in 'Nível', with: 'Junior'
      fill_in 'Lugar', with: 'Remote Job'
      fill_in 'Data', with: '21/11/2099'
      select 'draft', from: 'Status da Vaga'
      click_on 'Criar Vaga'
  
      expect(current_path).to eq job_path(1)
      expect(page).to have_content("Draft")
    end

    it 'without sucess' do
      headhunter = Headhunter.create!(:email => 'admin@test.com', :password => 'test123')
      login_as(headhunter, :scope => :headhunter)
      allow(SecureRandom).to receive(:alphanumeric).and_return('12345678')
      visit root_path
      
      within('nav') do
        click_on 'New Job Opening'
      end
      fill_in 'Título', with: ''
      fill_in 'Descrição', with: ''
      fill_in 'Habilidades', with: ''
      fill_in 'Salário', with: ''
      fill_in 'Empresa', with: ''
      fill_in 'Nível', with: ''
      fill_in 'Lugar', with: ''
      fill_in 'Data', with: ''
      click_on 'Criar Vaga'
  
      expect(page).to have_content("Job Opening was not registered.")
      expect(page).to have_content("Título não pode ficar em branco")
      expect(page).to have_content("Habilidades não pode ficar em branco")
      expect(page).to have_content("Salário não pode ficar em branco")
    end
end
