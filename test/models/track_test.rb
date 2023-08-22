# frozen_string_literal: true

require 'test_helper'

class TrackTest < ActiveSupport::TestCase
  test 'fixture is valid' do
    assert build(:track).valid?
  end

  test 'delegates artist to album' do
    track = build(:track)
    assert_equal track.artist, track.album.artist
  end
end
