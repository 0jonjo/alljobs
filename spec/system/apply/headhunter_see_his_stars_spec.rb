require 'rails_helper'

describe 'Headhunter see his stars' do

  let(:headhunter1) { create(:headhunter) }
  let(:headhunter2) { create(:headhunter) }
  let(:apply1) { create(:apply) }
  let(:apply2) { create(:apply) }

  before do
    login_as(headhunter1, :scope => :headhunter)
  end

  it 'with sucess' do
    Star.create(headhunter: headhunter1, apply: apply1)
    Star.create(headhunter: headhunter2, apply: apply2)

    visit root_path
    click_on I18n.t('stars')

    expect(page).to have_content(I18n.t('stars'))
    expect(page).to have_content(apply1.id)
    expect(page).to have_link(apply1.id.to_s, href: apply_path(apply1))
    expect(page).not_to have_content(apply2.id)
    expect(page).not_to have_link(apply2.id.to_s, href: apply_path(apply2))
  end

  it 'without sucess because there arent any star profile' do
    visit stars_path
    expect(page).to have_content(I18n.t('no_stars'))
  end

  it 'without sucess because there arent any star profile to this headhunter' do
    Star.create(headhunter: headhunter2, apply: apply2)

    visit stars_path

    expect(page).not_to have_content(apply2.id)
    expect(page).not_to have_link(apply2.id.to_s, href: apply_path(apply2))
    expect(page).to have_content(I18n.t('no_stars'))
  end
end
