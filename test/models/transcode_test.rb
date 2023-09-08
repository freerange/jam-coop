# frozen_string_literal: true

require 'test_helper'

class TranscodeTest < ActiveSupport::TestCase
  test 'fixture is valid' do
    assert build(:transcode).valid?
  end
end
