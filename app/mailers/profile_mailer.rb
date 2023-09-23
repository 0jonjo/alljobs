# frozen_string_literal: true

class ProfileMailer < ApplicationMailer
  def successful_action(profile_id, action, url)
    @profile = Profile.find(profile_id)
    @url = url
    @action = action
    email = User.find(@profile.user_id).email
    mail(to: email, subject: "Alljobs: You #{action}")
  end
end
