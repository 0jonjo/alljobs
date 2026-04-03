# frozen_string_literal: true

class ProfileMailer < ApplicationMailer
  def successful_action(profile_id, action, url)
    @profile = Profile.find(profile_id)
    @url = url
    @action = action
    mail(to: @profile.user.email, subject: "Alljobs: You #{action}")
  end
end
