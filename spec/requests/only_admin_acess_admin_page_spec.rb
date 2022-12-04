require 'rails_helper'

describe "Admin acess admin page" do
  it "with sucess" do
    admin = User.create!(:email => 'admin@test.com', :password => 'test123')
    login_as(admin, :scope => :admin)
    get(rails_admin_path)
    expect(response.status).to eq 200
  end
end 

describe "User try to acess a admin page" do
  it "and are redirect to admin login page" do
    user = User.create!(:email => 'user@test.com', :password => 'test123')
    profile = Profile.create!(name: 'Just a test', social_name: 'Just a test 2', birthdate: '21/03/1977',
                                educacional_background: "Test 3", experience: 'test 4', 
                                user_id: user.id)
    login_as(user, :scope => :user)
    get(rails_admin_path)
    expect(response).to redirect_to(new_admin_session_path)
  end
end    

describe "Headhunter try to acess a admin page" do
  it "and are redirect to admin login page" do
    headhunter = Headhunter.create!(:email => 'headhunter@test.com', :password => 'test123')
    login_as(headhunter, :scope => :headhunter)
    get(rails_admin_path)
    expect(response).to redirect_to(new_admin_session_path)
  end
end 
