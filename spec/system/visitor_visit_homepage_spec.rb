require 'rails_helper'

describe 'Visitor visit homepage' do
  it 'and view title and menu content' do
    visit root_path
    expect(page).to have_content('All Jobs')
    within('nav') do
      expect(page).to have_content('Login User')
      expect(page).to have_content('Login Headhunter')
      expect(page).not_to have_content('Logout User')
      expect(page).not_to have_content('Logout Headhunter')
      expect(page).not_to have_content('Openings')
      expect(page).not_to have_content('New Job Opening')
      expect(page).not_to have_content('Profiles')
      expect(page).not_to have_content('Stars')
      expect(page).not_to have_content('Applies')
    end  
  end
end