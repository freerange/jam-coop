# frozen_string_literal: true

require 'test_helper'

class ArtistTest < ActiveSupport::TestCase
  test 'fixture is valid' do
    assert build(:artist).valid?
  end
end
