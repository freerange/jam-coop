# frozen_string_literal: true

require 'test_helper'

module Admin
  class TracksControllerTestAsArtist < ActionDispatch::IntegrationTest
    setup do
      @album = create(:draft_album, :with_tracks)
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
      assert_redirected_to admin_artist_album_path(@album.artist, @album)
    end

    test 'should create multiple tracks' do
      blobs = [
        ActiveStorage::Blob.create_and_upload!(
          io: file_fixture('one.wav').open,
          filename: 'one.wav',
          content_type: 'audio/wav'
        ),
        ActiveStorage::Blob.create_and_upload!(
          io: file_fixture('two.wav').open,
          filename: 'two.wav',
          content_type: 'audio/wav'
        )
      ]

      assert_difference('Track.count', 2) do
        post create_multiple_admin_artist_album_tracks_path(@album.artist, @album), params: {
          original: blobs.map(&:signed_id)
        }
      end

      track1, track2 = Track.last(2)
      assert_equal(track1.title, 'one')
      assert_equal(track2.title, 'two')
      assert_redirected_to admin_artist_album_path(@album.artist, @album)
      assert_equal 'Tracks added', flash[:notice]
    end

    test 'should get edit' do
      get edit_admin_artist_album_track_path(@album.artist, @album, @album.tracks.first)
      assert_response :success
    end

    test 'should update track' do
      patch admin_artist_album_track_path(@album.artist, @album, @album.tracks.first),
            params: { track: { title: 'New title' } }
      assert_redirected_to admin_artist_album_path(@album.artist, @album)
    end

    test 'should delete track' do
      assert_difference('Track.count', -1) do
        delete admin_artist_album_track_path(@album.artist, @album, @album.tracks.first)
      end
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
      assert_redirected_to admin_artist_album_path(@album.artist, @album)
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
