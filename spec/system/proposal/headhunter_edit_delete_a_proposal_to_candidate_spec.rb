require 'rails_helper'

describe 'Headhunter' do
  context 'edit a proposal to a cadindidate' do

    let!(:headhunter) { create(:headhunter) }
    let!(:apply) { create(:apply) }
    let!(:proposal) { create(:proposal, apply: apply) }

    before do
      login_as(headhunter, :scope => :headhunter)
    end

    xit 'with sucess' do
      visit apply_proposal_path(apply, proposal)
      click_on I18n.t('edit')

      fill_in Proposal.human_attribute_name(:salary), with: '66'
      fill_in Proposal.human_attribute_name(:benefits), with: 'add other benefits'
      fill_in Proposal.human_attribute_name(:expectations), with: 'add other expectations'
      fill_in Proposal.human_attribute_name(:expected_start), with: '01/01/2099'
      click_on 'Atualizar Proposta'

      expect(page).to have_content("You successfully edited this proposal.")
      expect(current_path).to eq(apply_path(apply))
    end

    context 'without sucess -' do
      let!(:headhunter) { create(:headhunter) }
      let!(:apply) { create(:apply) }
      let!(:proposal) { create(:proposal, apply: apply) }

      before do
        login_as(headhunter, :scope => :headhunter)
      end

      xit "- incomplete informations" do
        visit apply_proposal_path(apply, proposal)
        click_on I18n.t('edit')

        fill_in Proposal.human_attribute_name(:salary), with: ''
        fill_in Proposal.human_attribute_name(:benefits), with: ''
        fill_in Proposal.human_attribute_name(:expectations), with: ''
        fill_in Proposal.human_attribute_name(:expected_start), with: ''
        click_on 'Atualizar Proposta'

        expect(page).to have_content("You do not edit this proposal.")
        expect(current_path).to eq(edit_apply_proposal_path(apply, proposal))
      end
    end
  end

  context 'delete a proposal to a cadindidate' do

    let!(:headhunter) { create(:headhunter) }
    let!(:apply) { create(:apply) }
    let!(:proposal) { create(:proposal, apply: apply) }

    before do
      login_as(headhunter, :scope => :headhunter)
    end

    xit 'with sucess' do
      visit apply_proposal_path(apply, proposal)
      click_on I18n.t('delete')

      expect(page).to have_content("You removed the proposal from the apply")
      expect(current_path).to eq(apply_path(apply))
    end
  end
end
