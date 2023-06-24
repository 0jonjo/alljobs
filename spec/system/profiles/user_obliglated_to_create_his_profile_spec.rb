require 'rails_helper'

describe "User obligated to create his profile" do

  let(:user) { create(:user) }
  let(:job) { create(:job) }

  before do
    login_as(user, :scope => :user)
  end

  it "when try to acess jobs" do
    visit jobs_path
    expect(current_path).to eq(new_profile_path)
  end

  it "when try to acess apply" do
    apply = create(:apply)
    visit apply_path(apply.id)
    expect(current_path).to eq(new_profile_path)
  end
end