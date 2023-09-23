# frozen_string_literal: true

require 'rails_helper'
require 'sidekiq/testing'

describe 'Headhunter' do
  let(:headhunter) { create(:headhunter) }

  before do
    login_as(headhunter, scope: :headhunter)
  end

  context 'remove an apply to job opening using Async Job' do
    it 'with sucess' do
      Sidekiq::Worker.clear_all
      apply = create(:apply)

      visit job_path(apply.job_id)
      click_on I18n.t('draft')

      expect(page).to have_content('draft')
      expect(page).not_to have_content('published')

      Sidekiq::Worker.drain_all

      visit job_path(apply.job_id)
      expect(page).not_to have_link(apply.user.email)
      expect(page).not_to have_link(apply.id.to_s)
    end
  end
end
