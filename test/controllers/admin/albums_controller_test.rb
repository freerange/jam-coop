# frozen_string_literal: true

require 'test_helper'

module Admin
  class AlbumsControllerTestSignedInAsAdmin < ActionDispatch::IntegrationTest
    def setup
      @album = create(:album, :with_tracks)
      @user = create(:user, admin: true)
      log_in_as(@user)
    end

    test '#new' do
      get new_admin_artist_album_path(@album.artist)
      assert_response :success
    end

    test '#create' do
      assert_difference('Album.count') do
        post admin_artist_albums_path(@album.artist), params: {
          album: { title: 'Example', cover: fixture_file_upload('cover.png'), license_id: License.first.id }
        }
      end

      assert_redirected_to artist_album_path(@album.artist, Album.last)
    end

    test '#create enqueues transcoding' do
      assert_enqueued_with(job: TranscodeJob) do
        post admin_artist_albums_path(@album.artist), params: {
          album: { title: 'Example',
                   cover: fixture_file_upload('cover.png'),
                   license_id: License.first.id,
                   tracks_attributes: { '0': { title: 'Test', original: fixture_file_upload('one.wav') } } }
        }
      end
    end

    test '#edit' do
      get edit_admin_artist_album_path(@album.artist, @album)
      assert_response :success
    end

    test '#update' do
      patch admin_artist_album_path(@album.artist, @album), params: { album: { title: 'Example' } }
      assert_redirected_to artist_album_path(@album.artist, @album)
    end

    test '#update accepts attributes for tracks' do
      track = create(:track, album: @album, title: 'Old name')

      patch admin_artist_album_path(@album.artist, @album),
            params: { album: { title: 'Example', tracks_attributes: { '0': { id: track.id, title: 'New name' } } } }

      assert_equal 'New name', track.reload.title
    end

    test '#update allows tracks to be destroyed' do
      track = create(:track, album: @album, title: 'Old name')

      assert_difference('Track.count', -1, 'A Track should be destroyed') do
        patch admin_artist_album_path(@album.artist, @album),
              params: { album: { title: 'Example', tracks_attributes: { '0': { id: track.id, _destroy: true } } } }
      end
    end
  end

  class AlbumsControllerTestSignedOut < ActionDispatch::IntegrationTest
    test '#new' do
      get new_admin_artist_album_path(album.artist)
      assert_redirected_to log_in_path
    end

    test '#create' do
      post admin_artist_albums_path(album.artist), params: { album: { title: 'Example' } }
      assert_redirected_to log_in_path
    end

    test '#edit' do
      get edit_admin_artist_album_path(album.artist, album)
      assert_redirected_to log_in_path
    end

    test '#update' do
      patch admin_artist_album_path(album.artist, album), params: { album: { title: 'Example' } }
      assert_redirected_to log_in_path
    end

    private

    def album
      @album ||= create(:published_album)
    end
  end
end
