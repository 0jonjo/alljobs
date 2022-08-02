class AppliesCleanupJob < ApplicationJob
  queue_as :default

  def perform(job_id)
    Apply.where(job_id: job_id).delete_all
  end
end
