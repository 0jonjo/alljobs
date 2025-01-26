# frozen_string_literal: true

require 'rails_helper'

describe 'Headhunter' do
  let(:headhunter) { create(:headhunter) }
  let!(:company) { create(:company) }
  let!(:country) { create(:country) }

  before do
    login_as(headhunter, scope: :headhunter)
  end

  context 'create a job opening' do
    it 'with success - status published' do
      allow(SecureRandom).to receive(:alphanumeric).and_return('12345678')

      visit root_path
      within('nav') do
        click_on I18n.t('new_opening')
      end

      fill_in Job.human_attribute_name(:title), with: 'Job Opening Test'
      fill_in Job.human_attribute_name(:description),
              with: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'
      fill_in Job.human_attribute_name(:skills),
              with: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'
      fill_in Job.human_attribute_name(:salary), with: '9999'
      select company.name, from: Job.human_attribute_name(:company_id)
      select 'Pleno', from: Job.human_attribute_name(:level)
      select country.acronym, from: Job.human_attribute_name(:country_id)
      fill_in Job.human_attribute_name(:city), with: 'City'
      fill_in Job.human_attribute_name(:date), with: 1.month.from_now
      select I18n.t('published'), from: Job.human_attribute_name(:job_status)
      click_on 'Criar Vaga'

      expect(page).to have_content('Job Opening Test')
      expect(page).to have_content('12345678')
      expect(page).to have_content('Test')
      expect(page).to have_content('Pleno')
      expect(page).to have_content('Publicada')
      expect(current_path).to eq job_path(Job.last.id)
    end

    it 'with success - status archived' do
      visit new_job_path

      fill_in Job.human_attribute_name(:title), with: 'Job Opening Test'
      fill_in Job.human_attribute_name(:description),
              with: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'
      fill_in Job.human_attribute_name(:skills),
              with: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'
      fill_in Job.human_attribute_name(:salary), with: '9999'
      select company.name, from: Job.human_attribute_name(:company_id)
      select 'Pleno', from: Job.human_attribute_name(:level)
      select country.acronym, from: Job.human_attribute_name(:country_id)
      fill_in Job.human_attribute_name(:city), with: 'City'
      fill_in Job.human_attribute_name(:date), with: 1.month.from_now
      select I18n.t('archived'), from: Job.human_attribute_name(:job_status)
      click_on 'Criar Vaga'

      expect(page).to have_content('Arquivada')
      expect(current_path).to eq job_path(Job.last.id)
    end

    it 'with success - status draft' do
      visit new_job_path

      fill_in Job.human_attribute_name(:title), with: 'Job Opening Test'
      fill_in Job.human_attribute_name(:description),
              with: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'
      fill_in Job.human_attribute_name(:skills),
              with: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'
      fill_in Job.human_attribute_name(:salary), with: '9999'
      select company.name, from: Job.human_attribute_name(:company_id)
      select 'Pleno', from: Job.human_attribute_name(:level)
      select country.acronym, from: Job.human_attribute_name(:country_id)
      fill_in Job.human_attribute_name(:city), with: 'City'
      fill_in Job.human_attribute_name(:date), with: 1.month.from_now
      select I18n.t('draft'), from: Job.human_attribute_name(:job_status)
      click_on 'Criar Vaga'

      expect(page).to have_content('Rascunho')
      expect(current_path).to eq job_path(Job.last.id)
    end

    it 'without success' do
      visit new_job_path

      fill_in Job.human_attribute_name(:title), with: ''
      fill_in Job.human_attribute_name(:description), with: ''
      fill_in Job.human_attribute_name(:skills), with: ''
      fill_in Job.human_attribute_name(:salary), with: ''
      fill_in Job.human_attribute_name(:date), with: ''
      select I18n.t('published'), from: Job.human_attribute_name(:job_status)
      click_on 'Criar Vaga'

      expect(page).to have_content('Título não pode ficar em branco')
      expect(page).to have_content('Habilidades não pode ficar em branco')
      expect(page).to have_content('Salário não pode ficar em branco')
      expect(current_path).to eq jobs_path
    end
  end
end
