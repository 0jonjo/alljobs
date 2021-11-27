require 'rails_helper'

describe 'Visit the homepage' do

    it 'create a User and create a profile' do
        
        visit root_path
        click_on 'New User'
        fill_in 'Email', with: 'usuario@disco1995.com.br'
        fill_in 'Password', with: 'd2blackalien'
        fill_in 'Password confirmation', with: 'd2blackalien'
        click_on 'Sign up'

        expect(current_path).to eq root_path
        expect(page).to have_content 'All Jobs'

        click_on 'Create Profile'
        fill_in 'Name', with: 'José Teste da Silva'
        fill_in 'Social name', with: 'Josefa Teste da Silva'
        fill_in 'Birthdate', with: '21/03/1977'
        fill_in 'Description', with: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eget ligula eu lectus lobortis condimentum. Aliquam nonummy auctor massa. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nulla at risus. Quisque purus magna, auctor et, sagittis ac, posuere eu, lectus. Nam mattis, felis ut adipiscing.'
        fill_in 'Educacional background', with: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eget ligula eu lectus lobortis condimentum. Aliquam nonummy auctor massa. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nulla at risus. Quisque purus magna, auctor et, sagittis ac, posuere eu, lectus. Nam mattis, felis ut adipiscing.'
        fill_in 'Experience', with: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eget ligula eu lectus lobortis condimentum. Aliquam nonummy auctor massa. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nulla at risus. Quisque purus magna, auctor et, sagittis ac, posuere eu, lectus. Nam mattis, felis ut adipiscing.'
        click_on 'Create Profile'

        expect(page).to have_content 'José Teste da Silva'
        click_on 'Return to Home'
        expect(page).to have_content 'All Jobs'
    end
end