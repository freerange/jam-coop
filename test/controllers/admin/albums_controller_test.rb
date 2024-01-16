# frozen_string_literal: true

require 'test_helper'

module Admin
  class AlbumsControllerTestSignedInAsAdmin < ActionDispatch::IntegrationTest
    def setup
      @album = create(:album, publication_status: :pending)
      @user = create(:user, admin: true)
      log_in_as(@user)
    end

    test '#index is authorized' do
      get admin_albums_path
      assert_response :success
    end

    test '#index lists pending albums' do
      get admin_albums_path
      assert_select 'li', text: "#{@album.title} by #{@album.artist.name}"
    end
  end

  class AlbumsControllerTestSignedOut < ActionDispatch::IntegrationTest
    test '#index is unauthorized' do
      get admin_albums_path
      assert_redirected_to log_in_url
    end
  end
end
