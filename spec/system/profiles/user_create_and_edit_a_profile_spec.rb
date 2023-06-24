require 'rails_helper'

describe 'User' do

  let(:user) { create(:user) }
  let(:country) { create(:country) }
  let(:country2) { create(:country) }

  before do
    login_as(user, :scope => :user)
  end

  context 'create a profile' do

    it 'with sucess' do
      visit root_path
      within('nav') do
        click_on Profile.model_name.human
      end

      expect(current_path).to eq new_profile_path
      puts page.body

      fill_in Profile.human_attribute_name(:name), with: 'User test name'
      fill_in Profile.human_attribute_name(:social_name), with: 'Social name test'
      fill_in Profile.human_attribute_name(:birthdate), with: '11/11/1911'
      fill_in Profile.human_attribute_name(:description), with: 'Test 1'
      fill_in Profile.human_attribute_name(:educacional_background), with: 'Test 2'
      fill_in Profile.human_attribute_name(:experience), with: 'Test 3'
      select country.acronym, from: Profile.human_attribute_name(:country_id)
      fill_in Profile.human_attribute_name(:city), with: 'Test 4'

      click_on 'Criar Perfil'

      expect(current_path).to eq profile_path(user)

      expect(page).not_to have_content 'User test name'
      expect(page).to have_content 'Social name test'
      expect(page).to have_content '11/11/1911'
      expect(page).to have_content 'Test 1'
      expect(page).to have_content 'Test 2'
      expect(page).to have_content 'Test 3'
      expect(page).to have_content 'Test 4'
      expect(page).to have_content country.name
    end

    it 'without sucess - forget some items' do
      visit root_path
      click_on Profile.model_name.human

      fill_in Profile.human_attribute_name(:name), with: ''
      fill_in Profile.human_attribute_name(:social_name), with: ''
      fill_in Profile.human_attribute_name(:birthdate), with: ''
      fill_in Profile.human_attribute_name(:experience), with: ''
      click_on 'Criar Perfil'

      expect(page).to have_content("Nome não pode ficar em branco")
      expect(page).to have_content("Data de Nascimento não pode ficar em branco")
      expect(page).to have_content("Experiência não pode ficar em branco")
      expect(current_path).to eq profiles_path
    end
  end

  context 'edit a profile' do

    it 'with sucess' do
      profile = Profile.create!(name: 'Just a test', social_name: 'Just a test 2',
                                birthdate: '21/03/1977', educacional_background: "Test 3",
                                experience: 'test 5', country: country, city: 'Test 5', user: user)
      visit root_path
      click_on Profile.model_name.human
      click_on I18n.t('edit')

      expect(current_path).to eq edit_profile_path(user)

      fill_in Profile.human_attribute_name(:name), with: 'User test name'
      fill_in Profile.human_attribute_name(:social_name), with: 'Social name test'
      fill_in Profile.human_attribute_name(:birthdate), with: '31/12/1931'
      fill_in Profile.human_attribute_name(:description), with: 'Test 6'
      fill_in Profile.human_attribute_name(:educacional_background), with: 'Test 7'
      fill_in Profile.human_attribute_name(:experience), with: 'Test 8'

      click_on 'Atualizar Perfil'
      expect(current_path).to eq profile_path(user)

      expect(page).to have_content 'Social name test'
      expect(page).to have_content '31/12/1931'
      expect(page).to have_content 'Test 6'
      expect(page).to have_content 'Test 7'
      expect(page).to have_content 'Test 8'
    end
  end
end