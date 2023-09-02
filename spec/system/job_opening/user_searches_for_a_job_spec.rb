# frozen_string_literal: true

require 'rails_helper'

describe 'User' do
  let(:profile) { create(:profile) }

  context 'acess form on menu and' do
    before do
      login_as(profile.user, scope: :user)
    end

    it 'search with sucess, only a result' do
      job = create(:job)

      visit root_path
      fill_in I18n.t('search_job'), with: job.code
      click_on I18n.t('search')

      expect(page).to have_content("1 #{I18n.t('jobs_found')}")
      expect(page).to have_link(job.code)
      expect(page).to have_link(job.title)
    end

    xit 'search with sucess, only correct results' do
      allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('ABC12345')
      job1 = create(:job)
      allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('ABC54321')
      job2 = create(:job)
      allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('ZZZZZZZZ')
      create(:job)

      visit root_path
      fill_in I18n.t('search_job'), with: 'ABC'
      click_on I18n.t('search')

      expect(page).to have_content('ABC')
      expect(page).to have_content(job1.code)
      expect(page).to have_content(job2.code)
      expect(page).not_to have_content('ZZZZZZZZ')
    end

    it 'search with sucess, no one result' do
      visit root_path
      fill_in I18n.t('search_job'), with: 'ZZZZZZZ'
      click_on I18n.t('search')

      expect(page).to have_content(I18n.t('no_jobs'))
      expect(page).not_to have_content(I18n.t('jobs_found'))
    end
  end
end
