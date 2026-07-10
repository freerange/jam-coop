# frozen_string_literal: true

module StripeConnectAccountHelper
  def options_for_stripe_connect_country_select
    [['🇬🇧 United Kingdom (GBP)', 'GB']]
  end

  def stripe_connect_country_text_from_country_code(country_code)
    options_for_stripe_connect_country_select.find { |_, cc| cc == country_code }&.first
  end

  def stripe_dashboard_url
    'https://dashboard.stripe.com/'
  end
end
