# frozen_string_literal: true

class ApplyCleanupJob < ApplicationJob
  def perform(apply_id)
    Apply.find(apply_id).destroy
  end
end
