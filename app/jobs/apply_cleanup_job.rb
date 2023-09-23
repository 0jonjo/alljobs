# frozen_string_literal: true

class ApplyCleanupJob
  include Sidekiq::Job

  def perform(apply_id)
    Apply.find(apply_id).destroy
  end
end
