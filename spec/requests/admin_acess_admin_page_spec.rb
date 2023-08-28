require 'rails_helper'

describe "Admin" do

  let(:admin) { create(:admin) }

  context 'acess admin page' do

    before do
      login_as(admin, :scope => :admin)
    end

    it "with sucess" do
      get(rails_admin_path)
      expect(response.status).to eq 200
    end
  end
end

describe "User" do

  let(:profile) { create(:profile) }

  context 'try to acess a admin page' do

    before do
      login_as(profile.user, :scope => :user)
    end

    it "and is redirect to admin login page" do
      get(rails_admin_path)
      expect(response).to redirect_to(new_admin_session_path)
    end
  end
end

describe "Headhunter" do

  let(:headhunter) { create(:headhunter) }

  context 'try to acess a admin page' do

    before do
      login_as(headhunter, :scope => :headhunter)
    end

    it "and is redirect to admin login page" do
      get(rails_admin_path)
      expect(response).to redirect_to(new_admin_session_path)
    end
  end
end