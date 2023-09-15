# frozen_string_literal: true

class ProfileMailer < ApplicationMailer
  def successful_action(profile, action, url)
    @profile = profile
    @url = url
    @action = action
    email = User.find(@profile.user_id).email
    mail(to: email, subject: "Alljobs: You #{action}")
  end
end
