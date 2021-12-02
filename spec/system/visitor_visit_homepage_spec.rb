require 'rails_helper'

describe 'Visitor visit homepage' do

  it 'and view title' do
    visit root_path
    expect(page).to have_content('All Jobs')
    expect(page).to have_content('Login User')
    expect(page).to have_content('New User')
    expect(page).to have_content('Login Headhunter')
    expect(page).to have_content('New Headhunter')
  end
end