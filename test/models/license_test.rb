# frozen_string_literal: true

require 'test_helper'

class LicenseTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  test 'fixture is valid' do
    assert build(:license).valid?
  end

  test 'is not valid if code is not present' do
    license = License.new

    assert_not license.valid?
    assert_includes license.errors[:code], "can't be blank"
  end

  test 'is not valid if label is not present' do
    license = License.new

    assert_not license.valid?
    assert_includes license.errors[:label], "can't be blank"
  end
end
