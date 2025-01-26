# frozen_string_literal: true

require 'rails_helper'

describe 'Headhunter' do
  let(:headhunter) { create(:headhunter) }
  let!(:job) { create(:job) }
  let!(:country) { create(:country) }
  let!(:company) { create(:company) }

  before do
    login_as(headhunter, scope: :headhunter)
  end

  context 'edit a job opening' do
    it 'with success' do
      visit jobs_path
      click_on job.title
      click_on I18n.t('edit')

      expect(current_path).to eq edit_job_path(job.id.to_s)

      fill_in Job.human_attribute_name(:title), with: 'Job Opening Test 123'
      fill_in Job.human_attribute_name(:description), with: 'Lorem ipsum dolor '
      fill_in Job.human_attribute_name(:skills), with: 'Lorem ipsuctus'
      fill_in Job.human_attribute_name(:salary), with: '9999'
      select company.name, from: Job.human_attribute_name(:company_id)
      select 'Pleno', from: Job.human_attribute_name(:level)
      select country.acronym, from: Job.human_attribute_name(:country_id)
      fill_in Job.human_attribute_name(:date), with: 1.month.from_now
      click_on 'Atualizar Vaga'

      expect(page).to have_content 'Job Opening Test 123'
      expect(page).to have_content 'R$ 9.999,00'
      expect(page).to have_content 'Pleno'
      expect(page).to have_content company.name
      expect(page).to have_content country.acronym
      expect(current_path).to eq job_path(job.id.to_s)
    end

    it 'without success' do
      visit edit_job_path(job.id.to_s)

      fill_in Job.human_attribute_name(:title), with: ''
      fill_in Job.human_attribute_name(:skills), with: ''
      fill_in Job.human_attribute_name(:salary), with: ''
      click_on 'Atualizar Vaga'

      expect(page).to have_content('Título não pode ficar em branco')
      expect(page).to have_content('Habilidades não pode ficar em branco')
      expect(page).to have_content('Salário não pode ficar em branco')
      expect(current_path).to eq job_path(job.id.to_s)
    end
  end
end
