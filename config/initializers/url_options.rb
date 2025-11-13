# frozen_string_literal: true

base_uri = URI.parse(Rails.configuration.base_url)

Rails.application.default_url_options = {
  protocol: base_uri.scheme,
  host: base_uri.host,
  port: base_uri.port
}
