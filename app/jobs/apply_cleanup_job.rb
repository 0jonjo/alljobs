# frozen_string_literal: true

class ApplyCleanupJob < ApplicationJob
  queue_as :default

  def perform(apply_id)
    Apply.find(apply_id).destroy
  end
end
