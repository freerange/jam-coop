# frozen_string_literal: true

require 'active_support/core_ext/integer/time'

Rails.application.routes.default_url_options = { host: 'jam.coop', protocol: 'https:' }

Rails.application.configure do
  config.enable_reloading = false
  config.eager_load = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true

  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present? || ENV['RENDER'].present?

  config.assets.compile = false

  config.active_storage.service = :amazon

  config.force_ssl = true

  config.logger = ActiveSupport::Logger.new($stdout)
                                       .tap  { |logger| logger.formatter = Logger::Formatter.new }
                                       .then { |logger| ActiveSupport::TaggedLogging.new(logger) }
  config.log_tags = [:request_id]
  config.log_level = ENV.fetch('RAILS_LOG_LEVEL', 'info')
  config.log_formatter = Logger::Formatter.new

  if ENV['RAILS_LOG_TO_STDOUT'].present?
    logger           = ActiveSupport::Logger.new($stdout)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end

  config.active_job.queue_adapter = :solid_queue

  config.action_mailer.perform_caching = false
  config.action_mailer.delivery_method = :postmark
  config.action_mailer.postmark_settings = {
    api_token: Rails.configuration.postmark[:api_key]
  }

  config.i18n.fallbacks = true

  config.active_support.report_deprecations = false

  config.active_record.dump_schema_after_migration = false
end
