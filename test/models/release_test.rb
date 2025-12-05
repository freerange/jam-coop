# frozen_string_literal: true

require 'test_helper'

class ReleaseTest < ActiveSupport::TestCase
  test 'factory is valid' do
    assert build(:release).valid?
  end
end
