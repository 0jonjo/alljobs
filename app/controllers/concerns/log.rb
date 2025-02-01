# frozen_string_literal: true

module Log
  def log_auth_request_success(class_name, email)
    logger.info(I18n.t('auth.log.auth_request_success', class_name:, email:))
  end

  def log_auth_request_fail(class_name, email)
    logger.info(I18n.t('auth.log.auth_request_fail', class_name:, email:))
  end
end
