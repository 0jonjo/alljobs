# frozen_string_literal: true

class SendMailSuccessUserJob
  include Sidekiq::Job

  def perform(profile_id, action, url)
    ProfileMailer.successful_action(profile_id, action, url).deliver_now
  end
end
