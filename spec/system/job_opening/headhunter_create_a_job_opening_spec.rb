require 'rails_helper'

describe 'Headhunter create a job opening' do
    it 'with sucess - status published' do
      headhunter = Headhunter.create!(:email => 'admin@test.com', :password => 'test123')
      login_as(headhunter, :scope => :headhunter)
      allow(SecureRandom).to receive(:alphanumeric).and_return('12345678')
      visit root_path
      
      within('nav') do
        click_on I18n.t('new_opening')
      end
      fill_in Job.human_attribute_name(:title), with: 'Job Opening Test'
      fill_in Job.human_attribute_name(:description), with: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eget ligula eu lectus lobortis condimentum. Aliquam nonummy auctor massa. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nulla at risus. Quisque purus magna, auctor et, sagittis ac, posuere eu, lectus. Nam mattis, felis ut adipiscing.'
      fill_in Job.human_attribute_name(:skills), with: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eget ligula eu lectus lobortis condimentum. Aliquam nonummy auctor massa. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nulla at risus. Quisque purus magna, auctor et, sagittis ac, posuere eu, lectus. Nam mattis, felis ut adipiscing.'
      fill_in Job.human_attribute_name(:salary), with: '9999'
      fill_in Job.human_attribute_name(:company), with: 'Test'
      fill_in Job.human_attribute_name(:level), with: 'Junior'
      fill_in Job.human_attribute_name(:place), with: 'Remote Job'
      fill_in Job.human_attribute_name(:date), with: '21/11/2099'
      select I18n.t('published'), from: Job.human_attribute_name(:job_status)
      click_on 'Criar Vaga'
  
      expect(current_path).to eq job_path(1)
      expect(page).to have_content("Job Opening Test")
      expect(page).to have_content("12345678")
      expect(page).to have_content("Test")
      expect(page).to have_content("Junior")
      expect(page).to have_content("21/11/2099")
      expect(page).to have_content(I18n.t('published'))
    end

    it 'with sucess - status archived' do
      headhunter = Headhunter.create!(:email => 'admin@test.com', :password => 'test123')
      login_as(headhunter, :scope => :headhunter)
      visit new_job_path
     
      fill_in Job.human_attribute_name(:title), with: 'Job Opening Test'
      fill_in Job.human_attribute_name(:description), with: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eget ligula eu lectus lobortis condimentum. Aliquam nonummy auctor massa. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nulla at risus. Quisque purus magna, auctor et, sagittis ac, posuere eu, lectus. Nam mattis, felis ut adipiscing.'
      fill_in Job.human_attribute_name(:skills), with: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eget ligula eu lectus lobortis condimentum. Aliquam nonummy auctor massa. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nulla at risus. Quisque purus magna, auctor et, sagittis ac, posuere eu, lectus. Nam mattis, felis ut adipiscing.'
      fill_in Job.human_attribute_name(:salary), with: '9999'
      fill_in Job.human_attribute_name(:company), with: 'Test'
      fill_in Job.human_attribute_name(:level), with: 'Junior'
      fill_in Job.human_attribute_name(:place), with: 'Remote Job'
      fill_in Job.human_attribute_name(:date), with: '21/11/2099'
      select I18n.t('archived'), from: Job.human_attribute_name(:job_status)
      click_on 'Criar Vaga'
  
      expect(current_path).to eq job_path(1)
      expect(page).to have_content(I18n.t('archived'))
    end

    it 'with sucess - status archived' do
      headhunter = Headhunter.create!(:email => 'admin@test.com', :password => 'test123')
      login_as(headhunter, :scope => :headhunter)
      visit new_job_path
     
      fill_in Job.human_attribute_name(:title), with: 'Job Opening Test'
      fill_in Job.human_attribute_name(:description), with: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eget ligula eu lectus lobortis condimentum. Aliquam nonummy auctor massa. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nulla at risus. Quisque purus magna, auctor et, sagittis ac, posuere eu, lectus. Nam mattis, felis ut adipiscing.'
      fill_in Job.human_attribute_name(:skills), with: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eget ligula eu lectus lobortis condimentum. Aliquam nonummy auctor massa. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nulla at risus. Quisque purus magna, auctor et, sagittis ac, posuere eu, lectus. Nam mattis, felis ut adipiscing.'
      fill_in Job.human_attribute_name(:salary), with: '9999'
      fill_in Job.human_attribute_name(:company), with: 'Test'
      fill_in Job.human_attribute_name(:level), with: 'Junior'
      fill_in Job.human_attribute_name(:place), with: 'Remote Job'
      fill_in Job.human_attribute_name(:date), with: '21/11/2099'
      select I18n.t('draft'), from: Job.human_attribute_name(:job_status)
      click_on 'Criar Vaga'
  
      expect(current_path).to eq job_path(1)
      expect(page).to have_content(I18n.t('draft'))
    end

    it 'without sucess' do
      headhunter = Headhunter.create!(:email => 'admin@test.com', :password => 'test123')
      login_as(headhunter, :scope => :headhunter)
      allow(SecureRandom).to receive(:alphanumeric).and_return('12345678')
      visit root_path
      
      within('nav') do
        click_on I18n.t('new_opening')
      end
      fill_in Job.human_attribute_name(:title), with: ''
      fill_in Job.human_attribute_name(:description), with: ''
      fill_in Job.human_attribute_name(:skills), with: ''
      fill_in Job.human_attribute_name(:salary), with: ''
      fill_in Job.human_attribute_name(:company), with: ''
      fill_in Job.human_attribute_name(:level), with: ''
      fill_in Job.human_attribute_name(:place), with: ''
      fill_in Job.human_attribute_name(:date), with: ''
      select I18n.t('published'), from: Job.human_attribute_name(:job_status)
      click_on 'Criar Vaga'
  
      expect(page).to have_content("Título não pode ficar em branco")
      expect(page).to have_content("Habilidades não pode ficar em branco")
      expect(page).to have_content("Salário não pode ficar em branco")
    end
end
