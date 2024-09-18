# frozen_string_literal: true

require 'rails_helper'
require 'sidekiq/testing'

describe 'User' do
  context 'access a proposal' do
    let!(:profile) { create(:profile) }
    let!(:apply) { create(:apply, user: profile.user) }
    let!(:proposal) { create(:proposal, apply:) }

    before do
      login_as(profile.user, scope: :user)
    end

    it 'and accept' do
      Sidekiq::Worker.clear_all
      visit apply_proposal_path(apply, proposal)
      click_on I18n.t('to_accept_proposal')

      expect(page).to have_content('You successfully accepted this proposal.')
      expect(page).to have_button(I18n.t('to_reject_proposal'))
      expect(page).not_to have_button(I18n.t('to_accept_proposal'))
      expect(current_path).to eq(apply_proposal_path(apply, proposal))
      expect(SendMailSuccessUserJob.jobs.size).to eq(1)
    end

    it 'and reject' do
      visit apply_proposal_path(apply, proposal)
      click_on I18n.t('to_reject_proposal')

      expect(page).to have_content('You successfully rejected this proposal.')
      expect(page).to have_button(I18n.t('to_accept_proposal'))
      expect(page).not_to have_button(I18n.t('to_reject_proposal'))
      expect(current_path).to eq(apply_proposal_path(apply, proposal))
    end
  end
end
