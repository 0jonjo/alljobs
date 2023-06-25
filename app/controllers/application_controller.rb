class ApplicationController < ActionController::Base

  def user_has_profile
    if user_signed_in?
      redirect_to new_profile_path if current_user.profile.blank?
    end
  end
end
