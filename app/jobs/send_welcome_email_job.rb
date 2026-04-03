# frozen_string_literal: true

class SendWelcomeEmailJob < ApplicationJob
  queue_as :default

  def perform(requester_type, requester_id)
    case requester_type
    when 'User'
      UserMailer.welcome(requester_id).deliver_now
    when 'Headhunter'
      HeadhunterMailer.welcome(requester_id).deliver_now
    else
      raise ArgumentError,
            "Unknown requester_type for SendWelcomeEmailJob: #{requester_type.inspect} (requester_id=#{requester_id})"
    end
  end
end
