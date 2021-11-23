require 'rails_helper'

describe 'Visitor visit homepage' do

  it 'and view title' do
    # Act
    visit root_path

    # Assert
    expect(page).to have_content('All Jobs')
  end
end