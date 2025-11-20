# frozen_string_literal: true

require 'test_helper'

module Admin
  class LabelsControllerTestSignedInAsOwner < ActionDispatch::IntegrationTest
    setup do
      @user = create(:user)
      log_in_as(@user)
      @label = create(:label, user: @user)
    end

    test '#new' do
      get new_admin_label_path
      assert_response :success
    end

    test '#edit' do
      get edit_admin_label_path(@label)
      assert_response :success
    end

    test '#create' do
      assert_difference('@user.labels.count') do
        post admin_labels_path, params: {
          label: { name: 'Test Label', logo: fixture_file_upload('cover.png') }
        }
      end

      assert_redirected_to account_path
      assert_equal 'Label was successfully created.', flash[:notice]
    end

    test '#create with invalid params' do
      assert_no_difference('@user.labels.count') do
        post admin_labels_path, params: {
          label: { name: '' }
        }
      end

      assert_response :unprocessable_content
    end

    test '#update' do
      patch admin_label_path(@label), params: {
        label: { name: 'Updated Name' }
      }

      assert_redirected_to account_path
      assert_equal 'Label was successfully updated.', flash[:notice]
      assert_equal 'Updated Name', @label.reload.name
    end

    test '#update with invalid params' do
      patch admin_label_path(@label), params: {
        label: { name: '' }
      }

      assert_response :unprocessable_content
    end
  end

  class LabelsControllerTestSignedInAsNonOwner < ActionDispatch::IntegrationTest
    setup do
      @user = create(:user)
      @other_user = create(:user)
      @label = create(:label, user: @other_user)
      log_in_as(@user)
    end

    test '#edit' do
      get edit_admin_label_path(@label)
      assert_response :not_found
    end

    test '#update' do
      patch admin_label_path(@label), params: {
        label: { name: 'Updated Name' }
      }
      assert_response :not_found
    end
  end

  class LabelsControllerTestSignedOut < ActionDispatch::IntegrationTest
    setup do
      @label = create(:label)
    end

    test '#new' do
      get new_admin_label_path
      assert_redirected_to log_in_path
    end

    test '#create' do
      post admin_labels_path, params: {
        label: { name: 'Test Label', location: 'Test Location', description: 'Test description' }
      }
      assert_redirected_to log_in_path
    end

    test '#edit' do
      get edit_admin_label_path(@label)
      assert_redirected_to log_in_path
    end

    test '#update' do
      patch admin_label_path(@label), params: {
        label: { name: 'Updated Name' }
      }
      assert_redirected_to log_in_path
    end
  end
end
