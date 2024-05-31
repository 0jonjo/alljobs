# frozen_string_literal: true

require "active_record"

class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :invalid_page

  def user_has_profile
    return unless user_signed_in?

    redirect_to new_profile_path if current_user.profile.blank?
  end

  def invalid_page
    logger.error "Attempt to access invalid page: #{request.url}"
    redirect_to root_url, notice: I18n.t("errors.messages.invalid_page")
  end
end
