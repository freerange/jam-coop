# frozen_string_literal: true

production_options = { host: 'cdn.jam.coop', protocol: 'https' }

options = Rails.env.production? ? production_options : Rails.application.default_url_options

Rails.configuration.cdn_url_options = options
