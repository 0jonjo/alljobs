require 'rails_helper'

RSpec.describe ApplyCleanupJob, type: :job do
  describe "Clean apply to a job opening" do
   it 'with sucess' do
      job_to_clean = Job.create!(title: 'Job Opening Test', description: 'Lorem ipsum', 
                                  skills: 'Nam mattis', salary: '99',
                                  company: 'Acme', level: 'Junior', place: 'Remote',
                                  date: 1.month.from_now, job_status: :published)
      user = User.create!(:email => "user@test.com", :password => 'test123')
      apply = Apply.create!(:job => job_to_clean, :user => user)     

      ApplyCleanupJob.perform_now(apply.id)
      
      apply_to_clean = Apply.where(job_id: job_to_clean.id).exists?
    
      expect(apply_to_clean).to be false
    end 
  end 
end