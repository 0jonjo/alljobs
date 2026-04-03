# frozen_string_literal: true

class SendApplyConfirmedEmailJob < ApplicationJob
  queue_as :default

  def perform(apply_id)
    UserMailer.apply_confirmed(apply_id).deliver_now
  end
end
