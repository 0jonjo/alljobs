require 'rails_helper'

describe 'Headhunter draft a job opening using Active Job' do
  it 'with sucess' do
    job = Job.create!(title: 'Job Opening Test', description: 'Lorem ipsum dolor sit amet', 
                          skills: 'Nam mattis, felis ut adipiscing.', salary: '99',
                          company: 'Acme', level: 'Junior', place: 'Remote Job',
                          date: 1.month.from_now, job_status: :published)
    user = User.create!(:email => 'user@test.com', :password => 'test123') 
    apply = Apply.create!(job: job, user: user)
    headhunter = Headhunter.create!(:email => 'admin@test.com', :password => 'test123')
    login_as(headhunter, :scope => :headhunter)
    visit job_path(job.id)
    
    click_on 'Change to Draft'
    expect(page).to have_content 'ID: 1'
    expect(page).to have_content 'Status Draft'
    expect(page).not_to have_content 'Published'
    
    ApplyListJob.perform_now(job.id)
    Delayed::Worker.new.work_off
    visit job_path(job.id)

    expect(page).to have_content 'There is no apply for this job.'
    expect(page).not_to have_content 'ID: 1'
  end
end
