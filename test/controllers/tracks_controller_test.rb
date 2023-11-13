# frozen_string_literal: true

require 'test_helper'

class TracksControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as(create(:user, admin: true))
    @track = create(:track)
  end

  test 'should move track higher' do
    post move_higher_track_url(@track)
    assert_redirected_to artist_album_url(@track.artist, @track.album)
  end

  test 'should move track lower' do
    post move_lower_track_url(@track)
    assert_redirected_to artist_album_url(@track.artist, @track.album)
  end
end
