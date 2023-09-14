# frozen_string_literal: true

class SendMailSuccessUserJob < ApplicationJob
  queue_as :default

  def perform(profile, action, url)
    ProfileMailer.successful_action(profile, action, url).deliver_now
  end
end
