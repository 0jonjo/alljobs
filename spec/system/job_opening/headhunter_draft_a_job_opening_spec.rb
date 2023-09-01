# frozen_string_literal: true

require 'rails_helper'

describe 'Headhunter' do
  let(:headhunter) { create(:headhunter) }
  let!(:apply) { create(:apply) }

  before do
    login_as(headhunter, scope: :headhunter)
  end

  context 'remove an apply to job opening using Active Job' do
    it 'with sucess' do
      ActiveJob::Base.queue_adapter = :delayed_job

      visit job_path(apply.job_id)
      click_on I18n.t('draft')

      expect(page).to have_content('draft')
      expect(page).not_to have_content('published')

      Delayed::Worker.new.work_off
      visit job_path(apply.job_id)

      expect(page).not_to have_link(apply.user.email)
      expect(page).not_to have_link(apply.id.to_s)
    end
  end
end
