# frozen_string_literal: true

require 'test_helper'

class StripeConnectAccountHelperTest < ActionView::TestCase
  test 'options_for_stripe_connect_country_select only include UK' do
    options = options_for_stripe_connect_country_select

    assert_equal 1, options.length
    assert_equal '🇬🇧 United Kingdom (GBP)', options[0].first
    assert_equal 'GB', options[0].last
  end

  test 'returns country/region option text for country code' do
    assert_equal '🇬🇧 United Kingdom (GBP)', stripe_connect_country_text_from_country_code('GB')
  end
end
