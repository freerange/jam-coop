# frozen_string_literal: true

require 'test_helper'

module Admin
  class TracksControllerTest < ActionDispatch::IntegrationTest
    setup do
      log_in_as(create(:user, admin: true))
      @track = create(:track, album: build(:draft_album))
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
