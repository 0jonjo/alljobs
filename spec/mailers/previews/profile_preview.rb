# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/profile
class ProfilePreview < ActionMailer::Preview
  def successful_action
    ProfileMailer.successful_action(Profile.last, 'created your profile', 'http://localhost:3000/rails/mailers/profile')
  end
end
