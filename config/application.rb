# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MusicCoop
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    config.eager_load_paths << Rails.root.join('app/form_builders')

    config.active_job.queue_adapter = :sidekiq

    config.middleware.use Rack::Maintenance, {
      file: Rails.public_path.join('maintenance.html'),
      env: 'MAINTENANCE'
    }

    config.postmark = config_for(:postmark)
    config.stripe = config_for(:stripe)
    config.aws = config_for(:aws)
    config.rollbar = config_for(:rollbar)
  end
end
