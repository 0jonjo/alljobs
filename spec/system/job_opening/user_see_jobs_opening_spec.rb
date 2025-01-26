# frozen_string_literal: true

require 'rails_helper'

describe 'User' do
  let(:profile) { create(:profile) }

  context 'see job openings' do
    before do
      login_as(profile.user, scope: :user)
    end

    it 'with success - only published' do
      job_published1 = create(:job, job_status: :published)
      job_published2 = create(:job, job_status: :published)
      job_archived = create(:job, job_status: :archived)

      visit jobs_path

      expect(page).to have_content(job_published1.title)
      expect(page).to have_content(job_published2.title)
      expect(page).not_to have_content(job_archived.title)
    end

    it 'without success - no one job' do
      visit jobs_path

      expect(page).to have_content(I18n.t('no_jobs'))
    end
  end
end
