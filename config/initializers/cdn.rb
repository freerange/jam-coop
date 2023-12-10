# frozen_string_literal: true

production_options = { host: 'cdn.jam.coop', protocol: 'https' }
default_options = { host: 'localhost', port: 3000 }

options = Rails.env.production? ? production_options : default_options

Rails.application.config.cdn_url_options = options
