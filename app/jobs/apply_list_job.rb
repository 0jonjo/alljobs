# frozen_string_literal: true

class ApplyListJob < ApplicationJob
  queue_as :default

  def perform(to_list)
    Apply.where(job_id: to_list).map { |apply| ApplyCleanupJob.perform_later(apply.id) }
  end
end
