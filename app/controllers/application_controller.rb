class ApplicationController < ActionController::Base

  def user_has_profile
    if user_signed_in?
      if current_user.profile.blank?
        redirect_to new_profile_path
      end
    end    
  end
end
