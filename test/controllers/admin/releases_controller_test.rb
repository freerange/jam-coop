# frozen_string_literal: true

require 'test_helper'

module Admin
  class ReleasesControllerTestSignedInAsOwner < ActionDispatch::IntegrationTest
    setup do
      @user = create(:user)
      log_in_as(@user)
      @label = create(:label, user: @user)
    end

    test '#new' do
      get new_admin_label_release_path(@label)
      assert_response :success
    end

    test '#edit' do
      release = create(:release, label: @label)
      get edit_admin_label_release_path(@label, release)
      assert_response :success
    end

    test '#create' do
      album = create(:album)

      assert_difference '@label.releases.count', 1 do
        post admin_label_releases_path(@label), params: { release: { album_id: album.id } }
      end
      assert_redirected_to edit_admin_label_path(@label)
    end

    test '#create with invalid params' do
      assert_no_difference '@label.releases.count' do
        post admin_label_releases_path(@label), params: { release: { album_id: nil } }
      end
      assert_response :unprocessable_content
    end

    test '#update' do
      release = create(:release, label: @label)
      new_album = create(:album)

      patch admin_label_release_path(@label, release), params: { release: { album_id: new_album.id } }
      assert_redirected_to edit_admin_label_path(@label)
      assert_equal new_album.id, release.reload.album_id
    end

    test '#update with invalid params' do
      release = create(:release, label: @label)

      patch admin_label_release_path(@label, release), params: { release: { album_id: nil } }
      assert_response :unprocessable_content
    end

    test '#destroy' do
      release = create(:release, label: @label)

      assert_difference '@label.releases.count', -1 do
        delete admin_label_release_path(@label, release)
      end
      assert_redirected_to edit_admin_label_path(@label)
    end
  end

  class ReleasesControllerTestSignedInAsNonOwner < ActionDispatch::IntegrationTest
    setup do
      @user = create(:user)
      @other_user = create(:user)
      @label = create(:label, user: @other_user)
      log_in_as(@user)
    end

    test '#new' do
      get new_admin_label_release_path(@label)
      assert_response :not_found
    end

    test '#edit' do
      release = create(:release, label: @label)
      get edit_admin_label_release_path(@label, release)
      assert_response :not_found
    end

    test '#create' do
      album = create(:album)

      post admin_label_releases_path(@label), params: { release: { album_id: album.id } }
      assert_response :not_found
    end

    test '#update' do
      release = create(:release, label: @label)
      new_album = create(:album)

      patch admin_label_release_path(@label, release), params: { release: { album_id: new_album.id } }
      assert_response :not_found
    end

    test '#destroy' do
      release = create(:release, label: @label)

      delete admin_label_release_path(@label, release)
      assert_response :not_found
    end
  end

  class ReleasesControllerTestSignedOut < ActionDispatch::IntegrationTest
    setup do
      @label = create(:label)
    end

    test '#new' do
      get new_admin_label_release_path(@label)
      assert_redirected_to log_in_path
    end

    test '#edit' do
      release = create(:release, label: @label)
      get edit_admin_label_release_path(@label, release)
      assert_redirected_to log_in_path
    end

    test '#create' do
      album = create(:album)
      post admin_label_releases_path(@label), params: { release: { album_id: album.id } }
      assert_redirected_to log_in_path
    end

    test '#update' do
      release = create(:release, label: @label)
      new_album = create(:album)

      patch admin_label_release_path(@label, release), params: { release: { album_id: new_album.id } }
      assert_redirected_to log_in_path
    end

    test '#destroy' do
      release = create(:release, label: @label)

      delete admin_label_release_path(@label, release)
      assert_redirected_to log_in_path
    end
  end
end
