# frozen_string_literal: true

require 'rails_helper'

describe 'Visitor visit homepage' do
  context 'when view title and menu content' do
    it 'only see login options' do
      visit root_path
      expect(page).to have_content('All Jobs')
      expect(page).to have_link('All Jobs', href: root_path)
      expect(page).to have_content(I18n.t('go_to_login'))
      within('nav') do
        expect(page).to have_link('Login User', href: new_user_session_path)
        expect(page).to have_link('Login Headhunter', href: new_headhunter_session_path)
        expect(page).not_to have_link(Profile.model_name.human, href: new_profile_path)
        expect(page).not_to have_link('Logout User', href: destroy_user_session_path)
        expect(page).not_to have_link('Logout Headhunter', href: destroy_headhunter_session_path)
        expect(page).not_to have_link(I18n.t('openings'), href: jobs_path)
        expect(page).not_to have_link(I18n.t('new_opening'), href: new_job_path)
        expect(page).not_to have_link(I18n.t('profiles'), href: profiles_path)
        expect(page).not_to have_link(I18n.t('stars'), href: stars_path)
        expect(page).not_to have_link(I18n.t('applies'), href: applies_path)
      end
    end
  end

  context 'when login as user and view title and menu content' do
    it 'see only user menu' do
      user = User.create!(email: 'user@test.com', password: 'test123')
      login_as(user, scope: :user)
      visit root_path

      expect(page).to have_content(I18n.t('choose_option'))
      expect(page).to have_link('All Jobs', href: root_path)
      within('nav') do
        expect(page).to have_content("#{I18n.t('you_are')} user@test.com")
        expect(page).to have_link(Profile.model_name.human, href: new_profile_path)
        expect(page).to have_link(I18n.t('openings'), href: jobs_path)
        expect(page).to have_link('Logout User', href: destroy_user_session_path)
        expect(page).to have_link(I18n.t('applies'), href: applies_path)
        expect(page).not_to have_link('Logout Headhunter', href: destroy_headhunter_session_path)
        expect(page).not_to have_link(I18n.t('new_opening'), href: new_job_path)
        expect(page).not_to have_link(I18n.t('profiles'), href: profiles_path)
        expect(page).not_to have_link(I18n.t('stars'), href: stars_path)
        expect(page).not_to have_link('Login User', href: new_user_session_path)
        expect(page).not_to have_link('Login Headhunter', href: new_headhunter_session_path)
      end
    end
  end

  context 'when login as headhunter and view title and menu content' do
    it 'see only the headhunter menu' do
      headhunter = Headhunter.create!(email: 'admin@test.com', password: 'test123')
      login_as(headhunter, scope: :headhunter)
      visit root_path

      expect(page).to have_content(I18n.t('choose_option'))
      expect(page).to have_link('All Jobs', href: root_path)
      within('nav') do
        expect(page).to have_content("#{I18n.t('you_are')} admin@test.com")
        expect(page).to have_link('Logout Headhunter', href: destroy_headhunter_session_path)
        expect(page).to have_link(I18n.t('new_opening'), href: new_job_path)
        expect(page).to have_link(I18n.t('profiles'), href: profiles_path)
        expect(page).to have_link(I18n.t('stars'), href: stars_path)
        expect(page).to have_link(I18n.t('openings'), href: jobs_path)
        expect(page).not_to have_link(I18n.t('applies'), href: applies_path)
        expect(page).not_to have_link(Profile.model_name.human, href: new_profile_path)
        expect(page).not_to have_link('Logout User', href: destroy_user_session_path)
        expect(page).not_to have_link('Login User', href: new_user_session_path)
        expect(page).not_to have_link('Login Headhunter', href: new_headhunter_session_path)
      end
    end
  end

  context 'when try to access a not found record' do
    it 'redirect to home page and return invalid page message' do
      visit profile_path(9_999_999_999)
      expect(current_path).to eq(root_path)
      expect(page).to have_content(I18n.t('errors.messages.invalid_page'))
    end
  end
end
