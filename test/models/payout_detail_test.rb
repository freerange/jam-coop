# frozen_string_literal: true

require 'test_helper'

class PayoutDetailTest < ActiveSupport::TestCase
  test 'fixture is valid' do
    assert build(:payout_detail).valid?
  end

  test 'country is required' do
    assert_not build(:payout_detail, country: nil).valid?
  end
end
