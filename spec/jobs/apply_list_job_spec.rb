# frozen_string_literal: true

require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe ApplyListJob, type: :job do
  describe 'Clean applies to a job opening' do
    it 'with sucess' do
      expect(ApplyCleanupJob.jobs.size).to eq(0)

      job_to_list = create(:job)
      create(:apply, job_id: job_to_list.id)
      create(:apply, job_id: job_to_list.id)

      ApplyListJob.new.perform(job_to_list.id)

      expect(ApplyCleanupJob.jobs.size).to eq(2)
    end
  end
end
