# frozen_string_literal: true

RailsCloudflareTurnstile.configure do |c|
  c.site_key = ENV.fetch('CLOUDFLARE_TURNSTILE_SITE_KEY')
  c.secret_key = ENV.fetch('CLOUDFLARE_TURNSTILE_SECRET_KEY')
  c.fail_open = true
  c.mock_enabled = false
end
