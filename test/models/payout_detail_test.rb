# frozen_string_literal: true

require 'test_helper'

class PayoutDetailTest < ActiveSupport::TestCase
  test 'fixture is valid' do
    assert build(:payout_detail).valid?
  end
end
