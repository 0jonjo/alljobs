# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplyListJob, type: :job do
  include ActiveJob::TestHelper
  before do
    ActiveJob::Base.queue_adapter = :test
  end

  describe 'Clean applies to a job opening' do
    it 'cleans applies to a job opening' do
      job_to_list = create(:job)
      create(:apply, job_id: job_to_list.id)
      create(:apply, job_id: job_to_list.id)

      expect do
        ApplyListJob.perform_later(job_to_list.id)
      end.to have_enqueued_job(ApplyListJob).with(job_to_list.id)

      perform_enqueued_jobs

      expect(enqueued_jobs.size).to eq(0)
      expect(Apply.where(job_id: job_to_list.id).size).to eq(0)
    end
  end
end
