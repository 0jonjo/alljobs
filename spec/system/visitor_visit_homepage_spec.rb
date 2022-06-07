require 'rails_helper'

describe 'Visitor visit homepage' do
  it 'and view title and menu content' do
    visit root_path
    expect(page).to have_content('All Jobs')
    expect(page).to have_link('All Jobs', href: root_path)
    within('nav') do
      expect(page).to have_link('Login User', href: new_user_session_path)
      expect(page).to have_link('Login Headhunter', href: new_headhunter_session_path)
      expect(page).not_to have_link('Create/Edit Profile', href: new_profile_path)
      expect(page).not_to have_link('Logout User', href: destroy_user_session_path)
      expect(page).not_to have_link('Logout Headhunter', href: destroy_headhunter_session_path)
      expect(page).not_to have_link('Openings', href: jobs_path)
      expect(page).not_to have_link('New Job Opening', href: new_job_path)
      expect(page).not_to have_link('Profiles', href: profiles_path)
      expect(page).not_to have_link('Stars', href: stars_path)
      expect(page).not_to have_link('Applies', href: applies_path)
    end
  end  
    
    it 'after User login and view title and menu content' do
      user = User.create!(:email => 'user@test.com', :password => 'test123')
      login_as(user, :scope => :user)
      visit root_path

      expect(page).to have_link('All Jobs', href: root_path)
      within('nav') do
        expect(page).to have_link('Create/Edit Profile', href: new_profile_path)
        expect(page).to have_link('Openings', href: jobs_path)
        expect(page).to have_link('Logout User', href: destroy_user_session_path)
        expect(page).not_to have_link('Applies', href: applies_path)
        expect(page).not_to have_link('Logout Headhunter', href: destroy_headhunter_session_path)
        expect(page).not_to have_link('New Job Opening', href: new_job_path)
        expect(page).not_to have_link('Profiles', href: profiles_path)
        expect(page).not_to have_link('Stars', href: stars_path)
        expect(page).not_to have_link('Login User', href: new_user_session_path)
        expect(page).not_to have_link('Login Headhunter', href: new_headhunter_session_path)
      end  
    end  

    it 'after Headhunter login and view title and menu content' do
      headhunter = Headhunter.create!(:email => 'admin@test.com', :password => 'test123')
      login_as(headhunter, :scope => :headhunter)
      visit root_path

      expect(page).to have_link('All Jobs', href: root_path)
      within('nav') do
        expect(page).to have_link('Applies', href: applies_path)
        expect(page).to have_link('Logout Headhunter', href: destroy_headhunter_session_path)
        expect(page).to have_link('New Job Opening', href: new_job_path)
        expect(page).to have_link('Profiles', href: profiles_path)
        expect(page).to have_link('Stars', href: stars_path)
        expect(page).to have_link('Openings', href: jobs_path)
        expect(page).not_to have_link('Create/Edit Profile', href: new_profile_path)
        expect(page).not_to have_link('Logout User', href: destroy_user_session_path)
        expect(page).not_to have_link('Login User', href: new_user_session_path)
        expect(page).not_to have_link('Login Headhunter', href: new_headhunter_session_path)
      end  
    end 
end