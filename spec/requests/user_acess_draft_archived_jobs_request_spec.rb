require 'rails_helper'


describe 'User' do

  let(:profile) { create(:profile) }


  before do
    login_as(profile.user, :scope => :user)
  end

  context 'try to acess archived job openings' do

    before do
      login_as(profile.user, :scope => :user)
    end

    it 'and is redirect to login as headhunter' do
      get(index_archived_jobs_path)
      expect(response).to redirect_to(new_headhunter_session_path)
    end
  end

  context 'try to acess draft job openings' do

    it 'and is redirect to login as headhunter' do
      get(index_draft_jobs_path)
      expect(response).to redirect_to(new_headhunter_session_path)
    end
  end
end
