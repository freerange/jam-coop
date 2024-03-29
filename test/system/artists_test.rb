# frozen_string_literal: true

require 'application_system_test_case'

class ArtistsTest < ApplicationSystemTestCase
  setup do
    @artist = build(:artist)
  end

  test 'adding a new artist' do
    admin = create(:user, admin: true)
    log_in_as(admin)

    visit artists_url
    click_link 'New artist'
    fill_in 'Name', with: @artist.name
    fill_in 'Location', with: @artist.location
    fill_in 'Description', with: @artist.description
    attach_file 'Profile picture', Rails.root.join('test/fixtures/files/cover.png')
    click_button 'Save'
    assert_selector 'h2', text: @artist.name
  end

  test 'editing a new artist' do
    @artist.save
    artist_user = create(:user, artists: [@artist])
    log_in_as(artist_user)

    visit artist_url(@artist)
    assert_text @artist.name
    click_link 'Edit artist'
    fill_in 'Name', with: 'New Artist Name'
    click_button 'Save'
    assert_text 'New Artist Name'
  end
end
