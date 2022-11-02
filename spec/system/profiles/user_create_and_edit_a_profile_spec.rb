require 'rails_helper'

describe 'User create a profile' do   
  it 'with sucess' do
      user = User.create!(:email => 'user@test.com', :password => 'test123')
      login_as(user, :scope => :user)
      visit root_path
      within('nav') do
        click_on 'Profile'
      end 
      
      expect(current_path).to eq new_profile_path

      fill_in 'Nome', with: 'User test name'
      fill_in 'Nome Social', with: 'Social name test'
      fill_in 'Data de Nascimento', with: '31/12/1931'
      fill_in 'Descrição', with: 'Test 1'
      fill_in 'Educação', with: 'Test 2'
      fill_in 'Experiência', with: 'Test 3'
      click_on 'Criar Perfil'

      expect(current_path).to eq profile_path(user)

      expect(page).to have_content "Profile registered."
      expect(page).not_to have_content 'User test name'
      expect(page).to have_content 'Social name test'
      expect(page).to have_content '1931-12-31'
      expect(page).to have_content 'Test 1'
      expect(page).to have_content 'Test 2'
      expect(page).to have_content 'Test 3'
  end

  it 'without sucess - forget some items' do
      user = User.create!(:email => 'user@test.com', :password => 'test123')
      login_as(user, :scope => :user)
      visit root_path
      click_on 'Profile'
    
      fill_in 'Nome', with: ''
      fill_in 'Nome Social', with: ''
      fill_in 'Data de Nascimento', with: ''
      fill_in 'Descrição', with: ''
      fill_in 'Educação', with: ''
      fill_in 'Experiência', with: ''
      click_on 'Criar Perfil'
      
      expect(page).to have_content "Profile doesn't registered."
      expect(page).to have_content("Nome não pode ficar em branco")
      expect(page).to have_content("Data de Nascimento não pode ficar em branco")
      expect(page).to have_content("Experiência não pode ficar em branco") 
      expect(current_path).to eq profiles_path
  end 
end   
      
describe 'User edit a profile' do
  it 'with sucess' do
        user = User.create!(:email => 'user@test.com', :password => 'test123')
        login_as(user, :scope => :user)
        profile = Profile.create!(name: 'Just a test', social_name: 'Just a test 2', birthdate: '21/03/1977',
                                  educacional_background: "Test 3", experience: 'test 4', user_id: user.id)
        visit root_path        
        click_on 'Profile'
        click_on 'Edit'

        expect(current_path).to eq edit_profile_path(user)

        fill_in 'Nome', with: 'User test name'
        fill_in 'Nome Social', with: 'Social name test'
        fill_in 'Data de Nascimento', with: '01/01/1900'
        fill_in 'Descrição', with: 'Test1'
        fill_in 'Educação', with: 'Test2'
        fill_in 'Experiência', with: 'Test3'

        click_on 'Atualizar Perfil'
        expect(current_path).to eq profile_path(user)
        
        expect(page).not_to have_content 'User test name'
        expect(page).not_to have_content 'Just a test 2'

        expect(page).to have_content 'Social name test'
        expect(page).to have_content '1900-01-01'
        expect(page).to have_content 'Test1'
        expect(page).to have_content 'Test2'
        expect(page).to have_content 'Test3'
      end

  it 'without sucess - forget items' do
        user = User.create!(:email => 'user@test.com', :password => 'test123')
        login_as(user, :scope => :user)
        profile = Profile.create!(name: 'Just a test', social_name: 'Just a test 2', birthdate: '21/03/1977',
                                  educacional_background: "Test 3", experience: 'test 4', user_id: user.id)
        visit root_path        
        click_on 'Profile'
        click_on 'Edit'

        expect(current_path).to eq edit_profile_path(user)

        fill_in 'Nome', with: ''
        fill_in 'Nome Social', with: ''
        fill_in 'Data de Nascimento', with: ''
        fill_in 'Descrição', with: ''
        fill_in 'Educação', with: ''
        fill_in 'Experiência', with: ''
        click_on 'Atualizar Perfil'

        expect(current_path).to eq profile_path(user)
        expect(page).to have_content "Profile doesn't edited."
        expect(page).to have_content("Nome não pode ficar em branco")
        expect(page).to have_content("Data de Nascimento não pode ficar em branco")
        expect(page).to have_content("Experiência não pode ficar em branco") 
      end  

      it 'without sucess - is not his profile' do
        user = User.create!(:email => 'user@test.com', :password => 'test123')
        user2 = User.create!(:email => 'user2@test.com', :password => 'test123')
        profile = Profile.create!(name: 'Just a test', social_name: 'Just a test 2', birthdate: '21/03/1977',
                                  educacional_background: "Test 3", experience: 'test 4', user_id: user.id)
        login_as(user2, :scope => :user)
        visit edit_profile_path(user)

        expect(current_path).to eq(root_path)
        expect(page).to have_content 'You do not have access to this profile.'
      end    
end