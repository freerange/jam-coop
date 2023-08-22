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
    click_on 'Save'

    assert_text "2. #{@track.title}"
  end
end
