require 'rails_helper'

RSpec.describe ApplyListJob, type: :job do
  describe "Clean applies to a job opening" do
    it 'with sucess' do
      ActiveJob::Base.queue_adapter = :test
      expect(Delayed::Job.count).to eq 0 
       job_to_list = Job.create!(title: 'Job Opening Test', description: 'Lorem ipsum', 
                         skills: 'Nam mattis', salary: '99',
                         company: 'Acme', level: 'Junior', place: 'Remote',
                         date: 1.month.from_now, job_status: :published)
       2.times do |n|
         user = User.create!(:email => "user#{n}@test.com", :password => 'test123')
         apply = Apply.create!(:job => job_to_list, :user => user) 
       end
    
       ApplyListJob.perform_now(job_to_list)
   
       expect(ApplyCleanupJob).to(have_been_enqueued.at_least(:twice))
     end 
   end 
end
