require 'rails_helper'

describe "User" do

  let(:profile) { create(:profile) }
  let(:apply) { create(:apply, user: profile.user) }
  let!(:proposal) { create(:proposal, apply: apply) }

  context 'see a proposal as a candidate' do

    before do
      login_as(profile.user, :scope => :user)
    end

    it "using apply link to proposal with sucess" do
      visit apply_path(apply)

      expect(page).to have_link(I18n.t('view_proposal'), href: apply_proposal_path(apply, proposal))
    end

    xit "direct to proposal page with sucess" do
      visit apply_proposal_path(apply, proposal)

      expect(page).to have_content("#{Proposal.model_name.human} 1")
      expect(page).to have_content(proposal.salary)
      expect(page).to have_content(proposal.benefits)
      expect(page).to have_content(proposal.expectations)
      expect(page).to have_link("#{Apply.human_attribute_name(:id)}: #{Apply.last.id}", href: apply_path(Apply.last.id))
      expect(page).to have_button(I18n.t('to_accept_proposal'))
      expect(page).to have_button(I18n.t('to_reject_proposal'))
    end
  end

  context 'try to see a proposal to another candidate' do

    let(:profile2) { create(:profile) }
    let!(:apply2) { create(:apply, user: profile2.user) }

    before do
      login_as(profile2.user, :scope => :user)
    end

    it "using apply link to proposal without sucess" do
      visit apply_path(apply)

      expect(page).not_to have_link(I18n.t('view_proposal'), href: apply_proposal_path(apply, proposal))
    end

    it "direct to proposal page without sucess" do
      visit apply_proposal_path(apply, proposal)

      expect(page).to have_content('You do not have access to this proposal.')
      expect(current_path).to eq(root_path)
    end
  end
end

