# frozen_string_literal: true

class ProfileMailer < ApplicationMailer
  def successful_action(profile, action)
    @profile = profile
    @url = 'http://localhost:3000/users/sign_in'
    @action = action
    email = User.find(@profile.user_id).email
    mail(to: email, subject: "Alljobs: You #{action}")
  end
end
