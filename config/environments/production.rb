# frozen_string_literal: true

require 'active_support/core_ext/integer/time'

Rails.application.configure do
  config.enable_reloading = false
  config.eager_load = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true

  config.public_file_server.headers = { 'cache-control' => "public, max-age=#{1.year.to_i}" }

  config.assets.compile = false

  config.active_storage.service = :amazon

  config.force_ssl = true

  config.log_tags = [:request_id]
  config.logger   = ActiveSupport::TaggedLogging.logger($stdout)

  config.log_level = ENV.fetch('RAILS_LOG_LEVEL', 'info')

  config.active_job.queue_adapter = :solid_queue

  config.action_mailer.perform_caching = false
  config.action_mailer.delivery_method = :postmark
  config.action_mailer.postmark_settings = {
    api_token: Rails.configuration.postmark[:api_key]
  }

  config.silence_healthcheck_path = '/up'

  config.i18n.fallbacks = true

  config.active_support.report_deprecations = false

  config.active_record.dump_schema_after_migration = false
  config.active_record.attributes_for_inspect = [:id]

  config.base_url = ENV.fetch('BASE_URL', 'https://jam.coop')
  config.cdn_base_url = ENV.fetch('CDN_BASE_URL', 'https://cdn.jam.coop')
end
