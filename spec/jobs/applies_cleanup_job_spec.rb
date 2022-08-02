require 'rails_helper'

RSpec.describe AppliesCleanupJob, type: :job do
  describe "Clean applies to a job opening" do
   it 'with sucess' do
      job_to_clean = Job.create!(title: 'Job Opening Test', description: 'Lorem ipsum', 
                        skills: 'Nam mattis', salary: '99',
                        company: 'Acme', level: 'Junior', place: 'Remote',
                        date: 1.month.from_now, job_status: :published)
      job = Job.create!(title: 'Job Opening Test 2', description: 'Lorem ipsum', 
                        skills: 'Nam mattis', salary: '99',
                        company: 'Acme', level: 'Junior', place: 'Remote',
                        date: 1.month.from_now, job_status: :published)
      10.times do |n|
        user = User.create!(:email => "user#{n}@test.com", :password => 'test123')
        apply = Apply.create!(:job => job_to_clean, :user => user) 
      end
    
      user_to_job = User.create!(:email => "userb@test.com", :password => 'test123')
      apply_to_job = Apply.create!(:job => job, :user => user_to_job)

      AppliesCleanupJob.perform_now(job_to_clean)

      applies_to_clean = Apply.where(job_id: job_to_clean.id).exists?
      applies = Apply.where(job_id: job.id).exists?

      expect(applies_to_clean).to be false
      expect(applies).to be true
    end 
  end 
end