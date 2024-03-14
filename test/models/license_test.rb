# frozen_string_literal: true

require 'test_helper'

class LicenseTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  test 'fixture is valid' do
    assert build(:license).valid?
  end

  test 'is not valid if requires attribuets are misising' do
    license = License.new

    assert_not license.valid?
    assert_includes license.errors[:code], "can't be blank"
    assert_includes license.errors[:label], "can't be blank"
  end
end
