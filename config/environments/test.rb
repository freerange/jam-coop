# frozen_string_literal: true

Rails.application.configure do
  config.enable_reloading = false
  config.eager_load = ENV['CI'].present?

  config.public_file_server.headers = { 'cache-control' => 'public, max-age=3600' }

  config.consider_all_requests_local = true
  config.cache_store = :null_store

  config.action_dispatch.show_exceptions = :rescuable

  config.action_controller.allow_forgery_protection = false

  config.active_storage.service = :test

  config.action_mailer.show_previews = true
  config.action_mailer.delivery_method = :test

  config.active_support.deprecation = :stderr

  config.action_controller.raise_on_missing_callback_actions = true

  config.after_initialize do
    Prosopite.raise = true
    Prosopite.allow_stack_paths = ['Admin::TracksController#create_multiple']
  end

  config.base_url = 'http://example.com'
  config.cdn_base_url = nil
end
