# frozen_string_literal: true

require 'rails_helper'

describe 'Headhunter' do
  let(:headhunter) { create(:headhunter) }

  before do
    login_as(headhunter, scope: :headhunter)
  end

  context 'access job openings' do
    it 'see published jobs with success' do
      jobtosee1 = create(:job)
      jobtosee2 = create(:job)
      job_archived = create(:job, job_status: :archived)

      visit jobs_path

      expect(page).to have_content(jobtosee1.title)
      expect(page).to have_content(jobtosee2.title)
      expect(page).not_to have_content(job_archived.title)
      expect(page).to have_link(I18n.t('archived'))
      expect(page).to have_link(I18n.t('draft'))
    end

    it 'see no one job published' do
      visit jobs_path

      expect(page).to have_content(I18n.t('no_jobs'))
    end
  end

  context 'access job openings' do
    it 'see draft jobs with success' do
      jobtosee1 = create(:job, job_status: :draft)
      jobtosee2 = create(:job, job_status: :draft)
      job_archived = create(:job, job_status: :archived)

      visit jobs_path
      click_on I18n.t('draft')

      expect(page).to have_content(jobtosee1.title)
      expect(page).to have_content(jobtosee2.title)
      expect(page).not_to have_content(job_archived.title)
      expect(page).to have_link(I18n.t('archived'))
      expect(page).to have_link(I18n.t('published'))
    end

    it 'see no one job published' do
      visit jobs_path
      click_on I18n.t('draft')

      expect(page).to have_content(I18n.t('no_jobs'))
    end
  end

  context 'access job openings' do
    it 'see archived jobs with success' do
      jobtosee1 = create(:job, job_status: :archived)
      jobtosee2 = create(:job, job_status: :archived)
      job_archived = create(:job, job_status: :draft)

      visit jobs_path
      click_on I18n.t('archived')

      expect(page).to have_content(jobtosee1.title)
      expect(page).to have_content(jobtosee2.title)
      expect(page).not_to have_content(job_archived.title)
      expect(page).to have_link(I18n.t('archived'))
      expect(page).to have_link(I18n.t('published'))
    end

    it 'see no one job published' do
      visit jobs_path
      click_on I18n.t('archived')

      expect(page).to have_content(I18n.t('no_jobs'))
    end
  end
end
