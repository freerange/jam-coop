# frozen_string_literal: true

require 'application_system_test_case'

class TracksTest < ApplicationSystemTestCase
  setup do
    sign_in_as(create(:user))
    @track = create(:track)
  end

  test 'should create track' do
    visit artist_album_url(@track.artist, @track.album)
    click_on 'Add track'

    fill_in 'Title', with: @track.title
    attach_file 'File', Rails.root.join('test/fixtures/files/track.wav')
    click_on 'Save'

    assert_text "2. #{@track.title}"
  end

  test 'editing a track' do
    visit artist_album_url(@track.artist, @track.album)
    assert_text "1. #{@track.title}"

    click_on 'Edit'
    fill_in 'Title', with: 'New title'
    click_on 'Save'

    assert_text '1. New title'
  end

  test 'deleting a track' do
    visit artist_album_url(@track.artist, @track.album)
    assert_text "1. #{@track.title}"

    accept_confirm do
      click_on 'Delete'
    end

    assert_no_text "1. #{@track.title}"
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
