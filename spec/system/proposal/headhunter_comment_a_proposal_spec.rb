# frozen_string_literal: true

require 'rails_helper'

describe 'Headhunter' do
  context 'makes a' do
    let(:headhunter) { create(:headhunter) }
    let(:apply) { create(:apply) }
    let(:proposal) { create(:proposal, apply:) }

    before do
      login_as(headhunter, scope: :headhunter)
    end

    context ' comment on a proposal' do
      it 'with success' do
        visit new_apply_proposal_proposal_comment_path(apply, proposal)

        fill_in 'proposal_comment[body]', with: 'Test Comment'
        click_on "#{I18n.t('new')} #{ProposalComment.model_name.human}"

        expect(page).to have_content('Comment created.')
        expect(current_path).to eq(apply_proposal_proposal_comments_path(apply.id, proposal.id))
      end

      it 'without success - blank comment' do
        visit new_apply_proposal_proposal_comment_path(apply, proposal)

        fill_in 'proposal_comment[body]', with: ''
        click_on "#{I18n.t('new')} #{ProposalComment.model_name.human}"

        expect(page).to have_content("Comment can't be created")
        expect(current_path).to eq(new_apply_proposal_proposal_comment_path(apply, proposal))
      end
    end

    context 'n edit to a comment on a proposal' do
      let!(:proposal_comment) do
        create(:proposal_comment, proposal_id: proposal.id,
                                  author_type: headhunter.class, author_id: headhunter.id)
      end

      it 'with success' do
        visit apply_proposal_proposal_comments_path(apply, proposal)

        click_on I18n.t('edit').to_s
        fill_in 'proposal_comment[body]', with: 'Test Comment'
        click_on "#{I18n.t('update')} #{ProposalComment.model_name.human}"

        expect(page).to have_content('Comment updated.')
        expect(current_path).to eq(apply_proposal_proposal_comments_path(apply.id, proposal.id))
      end

      it 'without success - blank comment' do
        visit apply_proposal_proposal_comments_path(apply, proposal)

        click_on I18n.t('edit').to_s
        fill_in 'proposal_comment[body]', with: ''
        click_on "#{I18n.t('update')} #{ProposalComment.model_name.human}"

        expect(page).to have_content("Comment can't be edited.")
        expect(current_path).to eq(edit_apply_proposal_proposal_comment_path(proposal.apply_id, proposal.id,
                                                                             proposal_comment.id))
      end
    end

    context 'n edit to a comment on a proposal' do
      let!(:proposal_comment) { create(:proposal_comment, proposal_id: proposal.id) }

      it 'without success - not his comment' do
        visit apply_proposal_proposal_comments_path(apply, proposal)

        expect(page).not_to have_content(I18n.t('edit').to_s)
        expect(page).not_to have_content(I18n.t('delete').to_s)
      end
    end

    context 'removal of a comment on a proposal' do
      let!(:proposal_comment_to_remove) do
        create(:proposal_comment, proposal_id: proposal.id,
                                  author_type: headhunter.class, author_id: headhunter.id)
      end

      it 'with success' do
        visit apply_proposal_proposal_comments_path(apply, proposal)

        click_on I18n.t('delete')

        expect(page).to have_content('Comment deleted.')
        expect(current_path).to eq(apply_proposal_proposal_comments_path(apply.id, proposal.id))
      end
    end
  end
end
