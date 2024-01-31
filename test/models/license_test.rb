# frozen_string_literal: true

require 'test_helper'

class LicenseTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  test 'fixture is valid' do
    assert build(:license).valid?
  end
end
