require 'rails_helper'

describe 'Headhunter see all profiles' do

  let(:headhunter) { create(:headhunter) }

  before do
    login_as(headhunter, :scope => :headhunter)
  end

  it 'with sucess' do
    profile1 = create(:profile)
    profile2 = create(:profile)
    profile3 = create(:profile)

    visit profiles_path

    expect(page).to have_content(profile1.social_name)
    expect(page).to have_content(profile2.social_name)
    expect(page).to have_content(profile3.social_name)
    expect(page).not_to have_content('There are no profiles registered') 
  end

  it "with no one profile registered" do
    visit profiles_path
    expect(page).to have_content(I18n.t('no_profiles'))
  end
end
