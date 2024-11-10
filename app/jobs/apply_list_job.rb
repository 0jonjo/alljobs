# frozen_string_literal: true

class ApplyListJob < ApplicationJob
  def perform(job_id)
    Apply.where(job_id:).map { |apply| ApplyCleanupJob.new.perform(apply.id) }
  end
end
