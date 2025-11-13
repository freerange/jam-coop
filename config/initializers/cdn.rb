# frozen_string_literal: true

cdn_base_uri = URI.parse(Rails.configuration.cdn_base_url)

Rails.configuration.cdn_url_options = {
  protocol: cdn_base_uri.scheme,
  host: cdn_base_uri.host,
  port: cdn_base_uri.port
}
