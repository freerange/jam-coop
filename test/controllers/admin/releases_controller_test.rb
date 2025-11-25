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
  end

  class ReleasesControllerTestSignedOut < ActionDispatch::IntegrationTest
    setup do
      @label = create(:label)
    end

    test '#new' do
      get new_admin_label_release_path(@label)
      assert_redirected_to log_in_path
    end
  end
end
