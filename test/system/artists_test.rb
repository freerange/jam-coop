# frozen_string_literal: true

require 'application_system_test_case'

class ArtistsTest < ApplicationSystemTestCase
  setup do
    sign_in_as(create(:user))
    @artist = build(:artist)
  end

  test 'adding a new artist' do
    visit artists_url
    click_on 'New artist'
    fill_in 'Name', with: @artist.name
    fill_in 'Location', with: @artist.location
    fill_in 'Description', with: @artist.description
    attach_file 'Profile picture', Rails.root.join('test/fixtures/files/cover.png')
    click_on 'Save'
    assert_selector 'h2', text: @artist.name
  end
end
