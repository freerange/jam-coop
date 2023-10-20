# frozen_string_literal: true

require 'test_helper'

class PurchasesControllerTest < ActionDispatch::IntegrationTest
  def setup
    sign_in_as(create(:user))
  end

  test 'should get new' do
    album = create(:album)

    get new_artist_album_purchase_url(album.artist, album)

    assert_response :success
  end
end
