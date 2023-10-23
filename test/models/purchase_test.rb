# frozen_string_literal: true

require 'test_helper'

class PurchaseTest < ActiveSupport::TestCase
  test 'fixture is valid' do
    assert build(:purchase).valid?
  end
end
