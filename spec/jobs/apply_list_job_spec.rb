# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplyListJob, type: :job do
  describe 'Clean applies to a job opening' do
    it 'with sucess' do
      ActiveJob::Base.queue_adapter = :test
      expect(Delayed::Job.count).to eq 0

      job_to_list = create(:job)
      create(:apply, job: job_to_list)
      create(:apply, job: job_to_list)

      ApplyListJob.perform_now(job_to_list)

      expect(ApplyCleanupJob).to(have_been_enqueued.at_least(:twice))
    end
  end
end
