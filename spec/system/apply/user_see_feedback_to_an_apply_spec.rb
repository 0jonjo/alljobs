require 'rails_helper'

describe 'User see feedback to an apply' do

  let(:user) { create(:user) }

  before do
    login_as(user, :scope => :user)
  end

  it "with sucess" do
    create(:profile, user: user)
    apply = create(:apply, user: user, feedback_headhunter: 'Test feedback')
    visit apply_path(apply)
    expect(page).to have_content("Test feedback")
  end

  it "and see feedback without sucess - not his apply" do
    user2 = create(:user)
    create(:profile, user: user2)
    login_as(user2, :scope => :user)
    apply = create(:apply, user: user, feedback_headhunter: 'Test feedback')
    visit apply_path(apply)

    expect(current_path).to eq(root_path)
    expect(page).not_to have_content("Test feedback")
  end
end

