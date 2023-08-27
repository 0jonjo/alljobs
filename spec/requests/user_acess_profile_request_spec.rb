require 'rails_helper'

describe 'User' do

  let(:profile) { create(:profile) }
  let!(:profile2) { create(:profile) }

  context 'try to acess a profile of other user' do

    before do
      login_as(profile.user, :scope => :user)
    end

    it 'and is redirect to root path' do
      get(profile_path(profile2.id))
      expect(response).to redirect_to(root_path)
    end
  end

  context 'try to acess edit page of profile of other user' do

    before do
      login_as(profile.user, :scope => :user)
    end

    it 'and is redirect to root path' do
      get(edit_profile_path(profile2.id))
      expect(response).to redirect_to(root_path)
    end
  end

  context 'try to acess all profiles' do

    before do
      login_as(profile.user, :scope => :user)
    end

    it 'and is redirect to login as headhunter ' do
      get(profiles_path)
      expect(response).to redirect_to(new_headhunter_session_path)
    end
  end
end
