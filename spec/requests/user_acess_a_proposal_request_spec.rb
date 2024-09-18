# frozen_string_literal: true

require 'rails_helper'

describe 'User' do
  let(:profile) { create(:profile) }
  let(:profile2) { create(:profile) }
  let(:apply) { create(:apply, user: profile2.user) }
  let(:proposal) { create(:proposal, apply:) }

  context 'try to acess an proposal of other user' do
    before do
      login_as(profile.user, scope: :user)
    end

    it 'and is redirect to root path' do
      get(apply_proposal_path(apply, proposal))
      expect(response).to redirect_to(root_path)
    end
  end
end
