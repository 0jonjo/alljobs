# frozen_string_literal: true

class SendWelcomeEmailJob < ApplicationJob
  queue_as :default

  def perform(requester_type, requester_id)
    case requester_type
    when 'User'
      UserMailer.welcome(requester_id).deliver_now
    when 'Headhunter'
      HeadhunterMailer.welcome(requester_id).deliver_now
    end
  end
end
