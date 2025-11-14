# frozen_string_literal: true

base_uri = URI.parse(Rails.configuration.base_url)

Rails.application.default_url_options = {
  protocol: base_uri.scheme,
  host: base_uri.host,
  port: base_uri.port
}

if Rails.configuration.cdn_base_url.present?
  cdn_base_uri = URI.parse(Rails.configuration.cdn_base_url)

  Rails.configuration.cdn_url_options = {
    protocol: cdn_base_uri.scheme,
    host: cdn_base_uri.host,
    port: cdn_base_uri.port
  }
else
  Rails.configuration.cdn_url_options = {}
end
