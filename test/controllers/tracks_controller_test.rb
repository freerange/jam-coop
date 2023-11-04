# frozen_string_literal: true

require 'test_helper'

class TracksControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as(create(:user))
    @track = create(:track)
  end

  test 'should get new' do
    get new_artist_album_track_url(@track.artist, @track.album)
    assert_response :success
  end

  test 'should create track' do
    assert_difference('Track.count') do
      post artist_album_tracks_url(@track.artist, @track.album), params: {
        track: { title: @track.title, original: fixture_file_upload('track.wav', 'audio/x-wav') }
      }
    end

    assert_redirected_to artist_album_url(Track.last.artist, Track.last.album)
  end

  test 'should move track higher' do
    post move_higher_artist_album_track_url(@track.artist, @track.album, @track)
    assert_redirected_to artist_album_url(@track.artist, @track.album)
  end

  test 'should move track lower' do
    post move_lower_artist_album_track_url(@track.artist, @track.album, @track)
    assert_redirected_to artist_album_url(@track.artist, @track.album)
  end
end
