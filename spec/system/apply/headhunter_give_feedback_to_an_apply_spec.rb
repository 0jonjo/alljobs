require 'rails_helper'

describe 'Headhunter gives feedback to an apply' do

  let(:headhunter) { create(:headhunter) }
  let(:apply) { create(:apply) }

  before do
    login_as(headhunter, :scope => :headhunter)
  end

  it 'with sucess' do
    visit apply_path(apply.id.to_s)

    click_on I18n.t('feedback')
    fill_in Apply.human_attribute_name(:feedback_headhunter), with: 'You need more experience to this job.'
    click_on "Atualizar Inscrição"

    expect(current_path).to eq(apply_path(apply))
    expect(page).to have_content("You need more experience to this job.")
  end

  it "and edit with sucess" do
    apply.feedback_headhunter = 'Just a comment.'
    visit apply_path(apply)

    click_on I18n.t('feedback')
    fill_in Apply.human_attribute_name(:feedback_headhunter), with: "Test edit feedback."
    click_on "Atualizar Inscrição"

    expect(current_path).to eq(apply_path(apply))
    expect(page).not_to have_content('Just a comment.')
    expect(page).to have_content('Test edit feedback.')
  end
end

