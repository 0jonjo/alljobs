require 'rails_helper'

describe 'User' do

  let!(:user) { create(:user) }
  let!(:country) { create(:country) }

  context 'see his profile' do
    before do
      login_as(user, :scope => :user)
    end

    it 'with sucess' do
      profile = create(:profile, user: user)
      visit root_path
      click_on Profile.model_name.human
      expect(current_path).to eq(profile_path(user.id))
    end

    it 'without sucess because do not have a profile' do
      visit root_path

      click_on Profile.model_name.human
      expect(current_path).to eq(new_profile_path)
    end
  end

  context 'try to see another profile' do

    let!(:profile) { create(:profile) }

    before do
      login_as(user, :scope => :user)
    end

    it 'without sucess because is not his profile' do
      visit profile_path(profile.id)
      expect(current_path).to eq(root_path)
    end
  end
end