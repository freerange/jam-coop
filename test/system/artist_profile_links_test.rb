# frozen_string_literal: true

require 'application_system_test_case'

class ArtistProfileLinksTest < ApplicationSystemTestCase
  setup do
    user = create(:user, verified: true)
    @artist = create(:artist, user:)

    log_in_as(user)
  end

  test 'creating a profile link' do
    visit edit_artist_path(@artist)
    click_on 'Add link'
    assert_text 'Link details'
    fill_in 'URL', with: 'http://artist.example.com'
    click_on 'Save'
    assert_text 'Link added'

    visit artist_path(@artist)
    assert_link 'http://artist.example.com'
  end
end
