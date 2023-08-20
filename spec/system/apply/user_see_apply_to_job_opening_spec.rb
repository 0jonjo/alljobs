require 'rails_helper'

describe 'User applied to job opening' do

  let(:profile) { create(:profile) }
  let(:apply) { create(:apply, user_id: profile.user_id) }

  before do
    login_as(profile.user, :scope => :user)
  end

  it 'and cant see other user apply' do
    apply2 = create(:apply)

    visit apply_path(apply2)
    expect(current_path).to eq(root_path)
  end

  it 'and see link to your apply and not to aplly again' do
    visit job_path(apply.job_id)
    expect(page).to have_link(I18n.t('your_apply'))
    expect(page).not_to have_link(I18n.t('to_apply'))
  end

  it "and see only his multiply applies in index" do
    apply
    another_apply_to_show = create(:apply, user_id: profile.user_id)
    apply_to_not_see = create(:apply)

    visit applies_path
    expect(page).to have_content(apply.job.title)
    expect(page).to have_content(another_apply_to_show.job.title)
    expect(page).not_to have_content(apply_to_not_see.job.title)
  end
end