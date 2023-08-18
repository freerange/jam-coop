# frozen_string_literal: true

require 'application_system_test_case'

class ArtistsTest < ApplicationSystemTestCase
  setup do
    @artist = build(:artist)
  end

  test 'adding a new artist' do
    visit artists_url
    click_on 'New artist'
    fill_in 'Name', with: @artist.name
    click_on 'Create Artist'
    assert_selector 'h1', text: @artist.name
  end
end
