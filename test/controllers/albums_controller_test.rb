# frozen_string_literal: true

require 'test_helper'

class AlbumsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @album = create(:album)
  end

  test '#show' do
    get album_url(@album)

    assert_response :success
  end
end
