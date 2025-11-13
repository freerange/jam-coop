# frozen_string_literal: true

require 'active_support/core_ext/integer/time'

Rails.application.configure do
  config.enable_reloading = true
  config.eager_load = false
  config.consider_all_requests_local = true
  config.server_timing = true

  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true

    config.cache_store = :memory_store
    config.public_file_server.headers = { 'Cache-Control' => "public, max-age=#{2.days.to_i}" }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  config.active_storage.service = :local

  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.perform_caching = false
  config.action_mailer.perform_deliveries = true
  if ENV['USE_POSTMARK_IN_DEVELOPMENT'] == 'true'
    config.action_mailer.delivery_method = :postmark
    config.action_mailer.postmark_settings = {
      api_token: Rails.configuration.postmark[:api_key]
    }
  else
    config.action_mailer.delivery_method = :letter_opener
  end

  config.active_support.deprecation = :log
  config.active_support.disallowed_deprecation = :raise
  config.active_support.disallowed_deprecation_warnings = []

  config.active_record.migration_error = :page_load
  config.active_record.verbose_query_logs = true

  config.active_job.queue_adapter = :solid_queue
  config.active_job.verbose_enqueue_logs = true

  config.assets.quiet = true

  config.action_view.annotate_rendered_view_with_filenames = true

  config.action_controller.raise_on_missing_callback_actions = true

  config.generators.apply_rubocop_autocorrect_after_generate!

  config.view_component.previews.default_layout = 'component_preview'

  config.after_initialize do
    Prosopite.raise = true
    Prosopite.allow_stack_paths = ['Track#transcode']
  end

  config.base_url = ENV.fetch('BASE_URL', 'http://localhost:3000')
  config.cdn_base_url = ENV.fetch('CDN_BASE_URL', config.base_url)

  config.hosts << URI.parse(Rails.configuration.base_url).host
end
