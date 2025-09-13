# frozen_string_literal: true

require 'application_system_test_case'

class ReorderingTracklistTest < ApplicationSystemTestCase
  setup do
    log_in_as(create(:user, admin: true))
    @track = create(:track, album: build(:draft_album))
  end

  test 're-ordering a tracklist' do
    first_track = @track
    second_track = create(:track, album: first_track.album, title: 'Second Track')

    visit artist_album_url(first_track.artist, first_track.album)

    assert_text "1. #{first_track.title}"
    assert_text "2. #{second_track.title}"

    first_down_link = all('a', text: 'Down').first
    first_down_link.click

    assert_text "1. #{second_track.title}"
    assert_text "2. #{first_track.title}"

    last_up_link = all('a', text: 'Up').last
    last_up_link.click

    assert_text "1. #{first_track.title}"
    assert_text "2. #{second_track.title}"
  end
end
