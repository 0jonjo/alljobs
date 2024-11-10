# frozen_string_literal: true

class SendMailSuccessUserJob < ApplicationJob
  def perform(profile_id, action, url)
    ProfileMailer.successful_action(profile_id, action, url).deliver_now
  end
end
