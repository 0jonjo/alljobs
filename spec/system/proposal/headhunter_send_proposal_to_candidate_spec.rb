# frozen_string_literal: true

require 'rails_helper'

describe 'Headhunter' do
  let(:headhunter) { create(:headhunter) }
  let(:apply) { create(:apply) }

  context 'send a proposal to a cadindidate' do
    before do
      login_as(headhunter, scope: :headhunter)
    end

    it 'with success' do
      visit apply_path(apply)
      click_on I18n.t('send_proposal')
      expect(current_path).to eq(new_apply_proposal_path(apply))

      fill_in Proposal.human_attribute_name(:salary), with: '9999'
      fill_in Proposal.human_attribute_name(:benefits), with: 'add benefits'
      fill_in Proposal.human_attribute_name(:expectations), with: 'add expectations'
      fill_in Proposal.human_attribute_name(:expected_start), with: '01/01/2099'
      click_on 'Criar Proposta'

      expect(page).to have_content('You successfully create a proposal for this apply.')
      expect(current_path).to eq(apply_path(apply))
    end

    it 'without success - incomplete' do
      visit new_apply_proposal_path(apply)

      fill_in Proposal.human_attribute_name(:salary), with: ''
      fill_in Proposal.human_attribute_name(:benefits), with: ''
      fill_in Proposal.human_attribute_name(:expectations), with: ''
      fill_in Proposal.human_attribute_name(:expected_start), with: ''
      click_on 'Criar Proposta'

      expect(page).to have_content("You can't create a proposal for this apply.")
      expect(current_path).to eq(new_apply_proposal_path(apply))
    end
  end

  context 'send a proposal to a cadindidate' do
    let!(:proposal) { create(:proposal, apply:) }

    before do
      login_as(headhunter, scope: :headhunter)
    end

    it 'without success - already have a proposal' do
      visit apply_path(apply)

      expect(page).not_to have_link(I18n.t('send_proposal'))
    end
  end
end
