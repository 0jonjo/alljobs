# frozen_string_literal: true

class ApplyListJob
  include Sidekiq::Job

  def perform(job_id)
    Apply.where(job_id:).map { |apply| ApplyCleanupJob.perform_async(apply.id) }
  end
end
