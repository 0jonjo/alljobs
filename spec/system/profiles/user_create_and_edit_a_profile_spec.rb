require 'rails_helper'

describe 'User create a profile' do   
  it 'with sucess' do
    user = User.create!(:email => 'user@test.com', :password => 'test123')
    login_as(user, :scope => :user)
    visit root_path
    within('nav') do
      click_on Profile.model_name.human
    end 
      
    expect(current_path).to eq new_profile_path

    fill_in Profile.human_attribute_name(:name), with: 'User test name'
    fill_in Profile.human_attribute_name(:social_name), with: 'Social name test'
    fill_in Profile.human_attribute_name(:birthdate), with: '31/12/1931'
    fill_in Profile.human_attribute_name(:description), with: 'Test 1'
    fill_in Profile.human_attribute_name(:educacional_background), with: 'Test 2'
    fill_in Profile.human_attribute_name(:experience), with: 'Test 3'
    click_on 'Criar Perfil'

    expect(current_path).to eq profile_path(user)

    expect(page).not_to have_content 'User test name'
    expect(page).to have_content 'Social name test'
    expect(page).to have_content '31/12/1931'
    expect(page).to have_content 'Test 1'
    expect(page).to have_content 'Test 2'
    expect(page).to have_content 'Test 3'
  end

  it 'without sucess - forget some items' do
    user = User.create!(:email => 'user@test.com', :password => 'test123')
    login_as(user, :scope => :user)
    visit root_path
    click_on Profile.model_name.human
    
    fill_in Profile.human_attribute_name(:name), with: ''
    fill_in Profile.human_attribute_name(:social_name), with: ''
    fill_in Profile.human_attribute_name(:birthdate), with: ''
    fill_in Profile.human_attribute_name(:description), with: ''
    fill_in Profile.human_attribute_name(:educacional_background), with: ''
    fill_in Profile.human_attribute_name(:experience), with: ''
    click_on 'Criar Perfil'
      
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
    click_on Profile.model_name.human
    click_on I18n.t('edit')

    expect(current_path).to eq edit_profile_path(user)

    fill_in Profile.human_attribute_name(:name), with: 'User test name'
    fill_in Profile.human_attribute_name(:social_name), with: 'Social name test'
    fill_in Profile.human_attribute_name(:birthdate), with: '31/12/1931'
    fill_in Profile.human_attribute_name(:description), with: 'Test 1'
    fill_in Profile.human_attribute_name(:educacional_background), with: 'Test 2'
    fill_in Profile.human_attribute_name(:experience), with: 'Test 3'

    click_on 'Atualizar Perfil'
    expect(current_path).to eq profile_path(user)
        
    expect(page).not_to have_content 'User test name'
    expect(page).not_to have_content 'Just a test 2'

    expect(page).to have_content 'Social name test'
    expect(page).to have_content '31/12/1931'
    expect(page).to have_content 'Test 1'
    expect(page).to have_content 'Test 2'
    expect(page).to have_content 'Test 3'
  end

  it 'without sucess - forget items' do
    user = User.create!(:email => 'user@test.com', :password => 'test123')
    login_as(user, :scope => :user)
    profile = Profile.create!(name: 'Just a test', social_name: 'Just a test 2', birthdate: '21/03/1977',
                                  educacional_background: "Test 3", experience: 'test 4', user_id: user.id)
    visit root_path        
    click_on Profile.model_name.human
    click_on I18n.t('edit')

    expect(current_path).to eq edit_profile_path(user)

    fill_in Profile.human_attribute_name(:name), with: ''
    fill_in Profile.human_attribute_name(:social_name), with: ''
    fill_in Profile.human_attribute_name(:birthdate), with: ''
    fill_in Profile.human_attribute_name(:description), with: ''
    fill_in Profile.human_attribute_name(:educacional_background), with: ''
    fill_in Profile.human_attribute_name(:experience), with: ''
    click_on 'Atualizar Perfil'

    expect(current_path).to eq profile_path(user)
    expect(page).to have_content("Nome não pode ficar em branco")
    expect(page).to have_content("Data de Nascimento não pode ficar em branco")
    expect(page).to have_content("Experiência não pode ficar em branco") 
  end  
end