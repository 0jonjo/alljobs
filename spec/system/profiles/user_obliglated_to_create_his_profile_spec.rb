require 'rails_helper'

describe "obligate user to create his profile" do
  it "when try to acess job" do
    user = User.create!(email: "user@test.com", password: "test123")
    login_as(user, :scope => :user)
    visit jobs_path
    expect(current_path).to eq(new_profile_path)
  end

  it "when try to acess apply" do
    job = Job.create!(title: 'Test 123', description: 'Lorem ipsum dolor sit amet', 
                        skills: 'Nam mattis, felis ut adipiscing.', salary: '99', 
                        company: 'Acme', level: 'Junior', place: 'Remote Job',
                        date: 1.month.from_now)                  
    user = User.create!(email: "user@test.com", password: "test123")
    apply = Apply.create!(user_id: user.id, job_id: job.id)  
    login_as(user, :scope => :user)
    visit apply_path(apply.id)
    expect(current_path).to eq(new_profile_path)
  end
end 