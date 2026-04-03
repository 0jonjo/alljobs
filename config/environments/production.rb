# frozen_string_literal: true

require 'active_support/core_ext/integer/time'

Rails.application.configure do
  config.eager_load = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true

  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?

  config.active_storage.service = :local

  config.force_ssl = true

  config.log_level = :info
  config.log_tags  = [:request_id]

  config.active_job.queue_adapter     = :solid_queue
  config.solid_queue.connects_to      = { database: { writing: :queue } }

  config.action_mailer.perform_caching = false

  config.i18n.fallbacks = true

  config.active_support.report_deprecations = false

  config.log_formatter = Logger::Formatter.new

  if ENV['RAILS_LOG_TO_STDOUT'].present?
    logger           = ActiveSupport::Logger.new($stdout)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end

  config.active_record.dump_schema_after_migration = false
end
