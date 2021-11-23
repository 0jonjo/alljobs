require 'rails_helper'

describe 'Visit the homepage' do

  it 'create The Headhunter' do
    
    visit root_path
    click_on 'New Headhunter'
    fill_in 'Email', with: 'herbiehancock@ndtheheadhunters.com'
    fill_in 'Password', with: 'watermelonman'
    fill_in 'Password confirmation', with: 'watermelonman'
    click_on 'Sign up'

    # Assert => Validar
    expect(current_path).to eq root_path
    expect(page).to have_content 'All Jobs'
  end
end