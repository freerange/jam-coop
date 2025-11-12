# frozen_string_literal: true

require 'test_helper'

class PlayersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @artist = create(:artist)
    @album = create(:album, :with_tracks, artist: @artist)
  end

  test '#show responds with 200 OK' do
    get artist_album_player_path(@artist, @album)
    assert_response :success
  end

  test '#show displays album title' do
    get artist_album_player_path(@artist, @album)
    assert_select 'h1', text: @album.title
  end

  test '#show displays artist name' do
    get artist_album_player_path(@artist, @album)
    assert_select 'h2', text: @artist.name
  end
end
