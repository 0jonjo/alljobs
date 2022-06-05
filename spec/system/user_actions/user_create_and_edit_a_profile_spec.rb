require 'rails_helper'

describe 'User create a profile' do   
    it 'with sucess' do
      user = User.create!(:email => 'user@test.com', :password => 'test123')
      login_as(user, :scope => :user)
      visit root_path
      within('nav') do
        click_on 'Create/Edit Profile'
      end  

      fill_in 'Name', with: 'User Test'
      fill_in 'Social name', with: 'Just a test'
      fill_in 'Birthdate', with: '31/12/1931'
      fill_in 'Description', with: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eget ligula eu lectus lobortis condimentum. Aliquam nonummy auctor massa. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nulla at risus. Quisque purus magna, auctor et, sagittis ac, posuere eu, lectus. Nam mattis, felis ut adipiscing.'
      fill_in 'Educacional background', with: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eget ligula eu lectus lobortis condimentum. Aliquam nonummy auctor massa. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nulla at risus. Quisque purus magna, auctor et, sagittis ac, posuere eu, lectus. Nam mattis, felis ut adipiscing.'
      fill_in 'Experience', with: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eget ligula eu lectus lobortis condimentum. Aliquam nonummy auctor massa. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nulla at risus. Quisque purus magna, auctor et, sagittis ac, posuere eu, lectus. Nam mattis, felis ut adipiscing.'
      click_on 'Create Profile'

      expect(page).to have_content 'Hahaha'
      click_on 'Return to Home'
      expect(page).to have_content 'All Jobs'
    end

    it 'edit profile' do
        
        user = User.create!(:email => 'usuario@disco1995.com.br', :password => 'd2blackalien')
        login_as(user, :scope => :user)
        visit root_path

        click_on 'Create/Edit Profile'
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
        
        click_on 'Create/Edit Profile'
        fill_in 'Name', with: 'Josefino Teste da Silva'

        click_on 'Update Profile'
        expect(page).to have_content 'Josefino Teste da Silva'
        click_on 'Return to Home'
        expect(page).to have_content 'All Jobs'
    end
end