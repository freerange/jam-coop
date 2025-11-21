# frozen_string_literal: true

require 'application_system_test_case'

class FollowingArtistsTest < ApplicationSystemTestCase
  test 'following artists' do
    artist = create(:artist, name: 'artist-name')
    create(:published_album, artist:, title: 'album-name', released_on: '2025-11-19')
    activity_feed_entry_title = 'artist-name released an album'
    activity_feed_entry_date = 'November 19, 2025'

    user = create(:user)
    log_in_as user

    visit artist_path(artist)
    click_on 'Follow'
    assert_text 'You are now following artist-name'
    click_on 'avatar'
    click_on 'My feed'

    assert_text activity_feed_entry_title
    assert_text activity_feed_entry_date

    visit artist_path(artist)
    click_on 'Unfollow'
    assert_text 'You are no longer following artist-name'
    click_on 'avatar'
    click_on 'My feed'

    assert_no_text activity_feed_entry_title
    assert_no_text activity_feed_entry_date
  end
end
