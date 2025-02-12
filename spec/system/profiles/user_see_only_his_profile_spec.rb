# frozen_string_literal: true

require 'rails_helper'

describe 'User' do
  context 'see his profile' do
    let!(:profile) { create(:profile) }

    before do
      login_as(profile.user, scope: :user)
    end

    it 'with success' do
      visit root_path
      click_on Profile.model_name.human
      expect(current_path).to eq(profile_path(profile.id))
    end
  end

  context 'see his profile' do
    let!(:user) { create(:user) }

    before do
      login_as(user, scope: :user)
    end

    it 'without success because do not have a profile' do
      visit root_path

      click_on Profile.model_name.human
      expect(current_path).to eq(new_profile_path)
    end
  end

  context 'try to see another profile' do
    let!(:user) { create(:user) }
    let!(:profile) { create(:profile) }

    before do
      login_as(user, scope: :user)
    end

    it 'without success because is not his profile' do
      visit profile_path(profile.id)
      expect(current_path).to eq(root_path)
    end
  end
end
