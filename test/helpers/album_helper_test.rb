# frozen_string_literal: true

require 'test_helper'

class AlbumHelperTest < ActionView::TestCase
  test 'seconds_to_formated_track_time' do
    assert_equal '03:05', seconds_to_formated_track_time(185)
    assert_equal '', seconds_to_formated_track_time(nil)
  end
end
