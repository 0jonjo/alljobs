# frozen_string_literal: true

require 'rails_helper'

describe 'Headhunter' do
  include ActiveJob::TestHelper

  let(:headhunter) { create(:headhunter) }

  before do
    ActiveJob::Base.queue_adapter = :test
    login_as(headhunter, scope: :headhunter)
  end

  context 'remove an apply to job opening using Async Job' do
    it 'with sucess' do
      apply = create(:apply)

      visit job_path(apply.job_id)
      click_on I18n.t('draft')

      expect(page).to have_content('Rascunho')

      perform_enqueued_jobs

      visit job_path(apply.job_id)
      expect(page).not_to have_link(apply.user.email)
      expect(page).not_to have_link(apply.id.to_s)
    end
  end
end
