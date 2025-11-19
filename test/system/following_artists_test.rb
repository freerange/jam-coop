# frozen_string_literal: true

require 'application_system_test_case'

class FollowingArtistsTest < ApplicationSystemTestCase
  test 'following artists' do
    artist = create(:artist, name: 'artist-name')
    create(:published_album, artist:, title: 'album-name', released_on: '2025-11-19')

    user = create(:user)
    log_in_as user

    visit artist_path(artist)
    click_on 'Follow'
    assert_text 'You are now following artist-name'
  end
end
