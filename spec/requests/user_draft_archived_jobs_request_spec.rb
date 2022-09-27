require 'rails_helper'

describe "User try to acess draft/achived index" do
  it "and are kicked from index draft to root_path" do
    user = User.create!(:email => 'user@test.com', :password => 'test123')
    profile = Profile.create!(name: 'Just a test', social_name: 'Just a test 2', birthdate: '21/03/1977',
                                educacional_background: "Test 3", experience: 'test 4', 
                                user_id: user.id)
    login_as(user, :scope => :user)
    get(index_draft_jobs_path)
    expect(response).to redirect_to(new_headhunter_session_path)
  end

  it "and are kicked from index archived to root_path" do
    user = User.create!(:email => 'user@test.com', :password => 'test123')
    profile = Profile.create!(name: 'Just a test', social_name: 'Just a test 2', birthdate: '21/03/1977',
                                educacional_background: "Test 3", experience: 'test 4', 
                                user_id: user.id)
    login_as(user, :scope => :user)
    get(index_archived_jobs_path)
    expect(response).to redirect_to(new_headhunter_session_path)
  end
end    
