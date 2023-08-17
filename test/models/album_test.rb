# frozen_string_literal: true

require 'test_helper'

class AlbumTest < ActiveSupport::TestCase
  test 'fixture is valid' do
    assert build(:album).valid?
  end
end
