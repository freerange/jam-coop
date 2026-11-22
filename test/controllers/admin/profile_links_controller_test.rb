# frozen_string_literal: true

require 'test_helper'

module Admin
  class ProfileLinksControllerTestAsArtist < ActionDispatch::IntegrationTest
    setup do
      user = create(:user, verified: true)
      @artist = create(:artist, user:)
      log_in_as(user)
    end

    test 'should get new' do
      get new_admin_artist_profile_link_path(@artist)
      assert_response :success
    end

    test 'should get edit' do
      profile_link = create(:profile_link, artist: @artist)
      get edit_admin_artist_profile_link_path(@artist, profile_link)
      assert_response :success
    end

    test 'should create a profile link' do
      assert_difference('ProfileLink.count') do
        post admin_artist_profile_links_path(@artist), params: {
          profile_link: { url: 'http://example.com' }
        }
      end
      assert_redirected_to edit_artist_path(@artist)
    end

    test 'should update a profile link' do
      profile_link = create(:profile_link, artist: @artist)
      patch admin_artist_profile_link_path(@artist, profile_link), params: {
        profile_link: { url: 'http://new.example.com' }
      }
      assert_redirected_to edit_artist_path(@artist)
    end
  end
end
