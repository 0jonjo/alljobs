require 'rails_helper'

describe 'Signup a Headhunter' do
  it 'with sucess' do
    visit root_path
    click_on 'Login Headhunter'
    click_on 'Sign up'
    fill_in 'Email', with: 'admin@test.com'
    fill_in 'Password', with: 'test123'
    fill_in 'Password confirmation', with: 'test123'
    click_on 'Sign up'

    expect(current_path).to eq root_path
    expect(page).to have_content 'All Jobs'
    expect(page).to have_content 'You are admin@test.com'
  end

  it 'without sucess' do
    visit root_path
    click_on 'Login Headhunter'
    click_on 'Sign up'
    fill_in 'Email', with: ''
    fill_in 'Password', with: ''
    fill_in 'Password confirmation', with: ''
    click_on 'Sign up'

    expect(page).to have_content 'All Jobs'
    expect(page).to have_content "Email can't be blank"
    expect(page).to have_content "Password can't be blank"
    expect(page).not_to have_content 'Logout'
  end
end