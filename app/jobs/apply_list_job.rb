class ApplyListJob < ApplicationJob
  queue_as :default

  def perform(job_id)
    Apply.where(job_id: job_id).each do |apply|
      ApplyCleanupJob.perform_later(apply.id)
    end
  end
end
