require 'rails_helper'

describe 'User' do

  let(:profile) { create(:profile) }

  context 'acess form on menu and' do

    before do
      login_as(profile.user, :scope => :user)
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
  end

  context 'search and receive only correct results' do

    before do
      login_as(profile.user, :scope => :user)
      allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('ABC12345')
      create(:job)
      allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('ABC54321')
      create(:job)
      allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('ZZZZZZZZ')
      create(:job)
    end

    it 'with sucess' do
      visit root_path
      fill_in I18n.t('search_job'), with: 'ABC'
      click_on I18n.t('search')

      expect(page).to have_content("ABC")
      expect(page).to have_content('Abc12345')
      expect(page).to have_content('Abc54321')
      expect(page).not_to have_content('ZZZZZZZZ')
    end
  end

  context 'search and receive no one result' do

    before do
      login_as(profile.user, :scope => :user)
    end

    it 'with sucess' do
      visit root_path
      fill_in I18n.t('search_job'), with: "ZZZZZZZ"
      click_on I18n.t('search')

      expect(page).to have_content(I18n.t('no_jobs'))
      expect(page).not_to have_content(I18n.t('jobs_found'))
    end
  end
end