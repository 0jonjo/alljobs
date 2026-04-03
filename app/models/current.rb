# frozen_string_literal: true

class Current < ActiveSupport::CurrentAttributes
  attribute :requester_id, :requester_type

  def user?
    requester_type == 'User'
  end

  def headhunter?
    requester_type == 'Headhunter'
  end
end
