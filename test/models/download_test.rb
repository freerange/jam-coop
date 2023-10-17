# frozen_string_literal: true

require 'test_helper'

class DownloadTest < ActiveSupport::TestCase
  test 'fixture is valid' do
    assert build(:track).valid?
  end
end
