# frozen_string_literal: true

require 'rails_helper'

describe 'Headhunter stars an apply' do
  let(:headhunter) { create(:headhunter) }
  let(:apply) { create(:apply) }

  before do
    login_as(headhunter, scope: :headhunter)
  end

  it 'with success and try again' do
    visit job_path(apply.job_id)

    click_on apply.id.to_s
    click_on I18n.t('star_apply')

    expect(page).to have_content('You successfully starred this apply.')
    click_on I18n.t('star_apply')
    expect(page).to have_content("You're already starred this apply.")
  end

  it 'remove a star with success' do
    Star.create!(headhunter_id: headhunter.id, apply_id: apply.id)

    visit root_path
    click_on I18n.t('stars')
    click_on I18n.t('delete')

    expect(page).to have_content(I18n.t('no_stars'))
  end
end
