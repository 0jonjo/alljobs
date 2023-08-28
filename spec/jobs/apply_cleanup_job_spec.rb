require 'rails_helper'

RSpec.describe ApplyCleanupJob, type: :job do
  describe "Clean apply to a job opening" do
   it 'with sucess' do
      job = create(:job)
      apply = create(:apply, job: job)

      ApplyCleanupJob.perform_now(apply.id)
      apply_to_clean = Apply.where(job_id: job.id)

      expect(apply_to_clean.exists?).to be false
    end
  end
end