# frozen_string_literal: true

require 'application_system_test_case'

class TaggingAnAlbumTest < ApplicationSystemTestCase
  # setup do
  #   create(:license)
  #   create(:tag, name: 'jazz')
  #   create(:tag, name: 'folk')
  #   @artist = create(:artist)
  #   @album = create(:album, artist: @artist)
  #   @artist_user = create(:user, artists: [@artist])
  # end

  # test 'creating an album' do
  #   log_in_as(@artist_user)
  #   visit edit_artist_album_path(@artist, @album)

  #   select 'jazz', from: 'Tags'
  #   select 'folk', from: 'Tags'

  #   click_on 'Save'

  #   assert_text 'Tags: folk, jazz'
  # end
end
