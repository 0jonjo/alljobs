require 'rails_helper'

describe 'Visitor visit homepage' do

  it 'and view title and menu content' do
    visit root_path
    expect(page).to have_content('All Jobs')
    expect(page).to have_content('Login User')
    expect(page).to have_content('Login Headhunter')
  end
end