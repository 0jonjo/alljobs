require 'rails_helper'

describe 'Headhunter' do

  let(:headhunter) { create(:headhunter) }
  let!(:job) { create(:job) }

  before do
    login_as(headhunter, :scope => :headhunter)
  end

  context 'when access the a job opening' do
    it 'can change stauts to draft with sucess ' do
      visit root_path

      click_on I18n.t('openings')
      click_on job.title
      click_on I18n.t('draft')

      expect(current_path).to eq job_path(job.id)

      expect(page).to have_content(Job.human_attribute_name(:job_status))
      expect(page).to have_content('draft')
    end

    it 'can change stauts to archived with sucess ' do
      visit job_path(job)

      expect(page).not_to have_button I18n.t('published')
      click_on I18n.t('archived')

      expect(current_path).to eq job_path(job.id)

      expect(page).to have_content('archived')
      expect(page).not_to have_content('published')
    end

    it 'can not change stauts to publish - do not can see the button' do
      visit job_path(job)

      expect(page).to have_content('published')
      expect(page).not_to have_button(I18n.t('published'))
      expect(page).to have_button(I18n.t('draft'))
      expect(page).to have_button(I18n.t('archived'))
    end
  end
end
