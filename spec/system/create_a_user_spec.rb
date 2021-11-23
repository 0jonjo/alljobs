require 'rails_helper'

describe 'Visit the homepage' do

  it 'create a User' do
    
    visit root_path
    click_on 'New User'
    fill_in 'Email', with: 'usuario@disco1995.com.br'
    fill_in 'Password', with: 'd2blackalien'
    fill_in 'Password confirmation', with: 'd2blackalien'
    click_on 'Sign up'

    # Assert => Validar
    expect(current_path).to eq root_path
    expect(page).to have_content 'All Jobs'
  end
end