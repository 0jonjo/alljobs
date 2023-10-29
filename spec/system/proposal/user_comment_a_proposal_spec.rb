# frozen_string_literal: true

require 'rails_helper'

describe 'User' do
  context 'comment a proposal' do
    let(:profile) { create(:profile) }
    let(:apply) { create(:apply, user_id: profile.user_id) }
    let(:proposal) { create(:proposal, apply: apply) }

    before do
      login_as(profile.user, scope: :user)
    end

    it 'with sucess' do
      visit new_apply_proposal_proposal_comment_path(apply, proposal)

      fill_in 'proposal_comment[body]', with: 'Test Comment'
      click_on "#{I18n.t('new')} #{ProposalComment.model_name.human}"

      expect(page).to have_content('Comment created.')
      expect(current_path).to eq(apply_proposal_proposal_comments_path(apply.id, proposal.id))
    end

    it 'without sucess - blank comment' do
      visit new_apply_proposal_proposal_comment_path(apply, proposal)

      fill_in 'proposal_comment[body]', with: ''
      click_on "#{I18n.t('new')} #{ProposalComment.model_name.human}"

      expect(page).to have_content("Comment can't be created")
      expect(current_path).to eq(new_apply_proposal_proposal_comment_path(apply, proposal))
    end
  end
end
