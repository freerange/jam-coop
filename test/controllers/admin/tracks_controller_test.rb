# frozen_string_literal: true

require 'test_helper'

module Admin
  class TracksControllerTestAsArtist < ActionDispatch::IntegrationTest
    setup do
      @album = create(:draft_album)
      user = create(:user)
      user.artists << @album.artist
      log_in_as(user)
    end

    test 'should get new' do
      get new_admin_artist_album_track_path(@album.artist, @album)
      assert_response :success
    end

    test 'should create track' do
      assert_difference('Track.count') do
        post admin_artist_album_tracks_path(@album.artist, @album), params: {
          track: { title: 'New Track', original: fixture_file_upload('one.wav', 'audio/wav') }
        }
      end
      assert_redirected_to edit_admin_artist_album_path(@album.artist, @album)
    end
  end

  class TracksControllerTestAsAdmin < ActionDispatch::IntegrationTest
    setup do
      @admin = create(:user, admin: true)
      @album = create(:draft_album)
      @track = create(:track, album: @album)

      log_in_as(@admin)
    end

    test 'should get new' do
      get new_admin_artist_album_track_path(@album.artist, @album)
      assert_response :success
    end

    test 'should create track' do
      assert_difference('Track.count') do
        post admin_artist_album_tracks_path(@album.artist, @album), params: {
          track: { title: 'New Track', original: fixture_file_upload('one.wav', 'audio/wav') }
        }
      end
      assert_redirected_to edit_admin_artist_album_path(@album.artist, @album)
    end

    test 'should move track higher' do
      post move_higher_admin_artist_album_track_path(@track.artist, @track.album, @track)
      assert_redirected_to artist_album_path(@track.artist, @track.album)
    end

    test 'should move track lower' do
      post move_lower_admin_artist_album_track_path(@track.artist, @track.album, @track)
      assert_redirected_to artist_album_path(@track.artist, @track.album)
    end
  end
end
