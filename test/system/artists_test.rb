# frozen_string_literal: true

require 'application_system_test_case'

class ArtistsTest < ApplicationSystemTestCase
  setup do
    @artist = build(:artist)
  end

  test 'adding a new artist' do
    user = create(:user)
    log_in_as(user)

    visit account_path
    click_on 'Add artist profile'

    within(details_section) do
      fill_in 'Name', with: @artist.name
      fill_in 'Location', with: @artist.location
      fill_in 'Description', with: @artist.description
      attach_file 'Profile picture', Rails.root.join('test/fixtures/files/cover.png')
      click_on 'Save'
    end

    visit artist_path(Artist.last)
    assert_text @artist.name
  end

  test 'editing a new artist' do
    @artist.save
    artist_user = create(:user, artists: [@artist])
    log_in_as(artist_user)

    visit edit_artist_url(@artist)
    within(details_section) do
      fill_in 'Name', with: 'New Artist Name'
      click_on 'Save'
    end

    visit artist_url(@artist)
    assert_text 'New Artist Name'
  end

  private

  def details_section
    find('h2', text: 'Artist details').ancestor('section')
  end
end
