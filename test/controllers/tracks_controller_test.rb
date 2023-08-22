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
        track: { title: @track.title }
      }
    end

    assert_redirected_to artist_album_url(Track.last.artist, Track.last.album)
  end

  test 'should get edit' do
    get edit_artist_album_track_url(@track.artist, @track.album, @track)
    assert_response :success
  end

  test 'should update track' do
    patch artist_album_track_url(@track.artist, @track.album, @track), params: { track: { title: @track.title } }
    assert_redirected_to artist_album_url(@track.artist, @track.album)
  end

  test 'should destroy track' do
    assert_difference('Track.count', -1) do
      delete artist_album_track_url(@track.artist, @track.album, @track)
    end

    assert_redirected_to artist_album_url(@track.artist, @track.album)
  end
end
