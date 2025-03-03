# frozen_string_literal: true

require 'rails_helper'

describe 'User' do
  let(:profile) { create(:profile) }
  let(:profile2) { create(:profile) }
  let(:apply) { create(:apply, user: profile2.user) }

  context 'try to access an apply of other user' do
    before do
      login_as(profile.user, scope: :user)
    end

    it 'and is redirect to create root path' do
      get(apply_path(apply))
      expect(response).to redirect_to(root_path)
    end
  end
end
