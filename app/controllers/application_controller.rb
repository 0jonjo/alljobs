class ApplicationController < ActionController::Base

  protected
  def after_sign_in_path_for(resource)
    if user_signed_in?
      if current_user.profiles.exists?
        new_profile_path
      else
        root_path
      end
    else
      root_path
    end
  end
end
