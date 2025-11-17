# frozen_string_literal: true

require 'test_helper'

module Admin
  class NewslettersControllerTestSignedInAsAdmin < ActionDispatch::IntegrationTest
    setup do
      @user = create(:user, admin: true)
      log_in_as(@user)
    end

    test '#index' do
      get admin_newsletters_path
      assert_response :success
    end

    test '#new' do
      get new_admin_newsletter_path
      assert_response :success
    end

    test '#create' do
      assert_difference('Newsletter.count') do
        post admin_newsletters_path, params: {
          newsletter: { title: 'Test Newsletter', body: 'Test body content' }
        }
      end

      assert_redirected_to edit_admin_newsletter_path(Newsletter.last)
      assert_equal 'Newsletter was successfully created.', flash[:notice]
    end

    test '#create with invalid params' do
      assert_no_difference('Newsletter.count') do
        post admin_newsletters_path, params: {
          newsletter: { title: '', body: '' }
        }
      end

      assert_response :unprocessable_content
    end

    test '#edit' do
      newsletter = create(:newsletter)
      get edit_admin_newsletter_path(newsletter)
      assert_response :success
    end

    test '#update' do
      newsletter = create(:newsletter)
      patch admin_newsletter_path(newsletter), params: {
        newsletter: { title: 'Updated Title' }
      }

      assert_redirected_to edit_admin_newsletter_path(newsletter)
      assert_equal 'Newsletter was successfully updated.', flash[:notice]
      assert_equal 'Updated Title', newsletter.reload.title
    end

    test '#update with invalid params' do
      newsletter = create(:newsletter)
      patch admin_newsletter_path(newsletter), params: {
        newsletter: { title: '' }
      }

      assert_response :unprocessable_content
    end
  end
end

module Admin
  class NewslettersControllerTestSignedInAsNonAdmin < ActionDispatch::IntegrationTest
    setup do
      @user = create(:user, admin: false)
      log_in_as(@user)
    end

    test '#index not authorized' do
      get admin_newsletters_path
      assert_redirected_to root_path
      assert_equal 'You are not authorized to perform this action.', flash[:alert]
    end

    test '#new not authorized' do
      get new_admin_newsletter_path
      assert_redirected_to root_path
      assert_equal 'You are not authorized to perform this action.', flash[:alert]
    end

    test '#create not authorized' do
      assert_no_difference('Newsletter.count') do
        post admin_newsletters_path, params: {
          newsletter: { title: 'Test Newsletter', body: 'Test body content' }
        }
      end

      assert_redirected_to root_path
      assert_equal 'You are not authorized to perform this action.', flash[:alert]
    end

    test '#edit not authorized' do
      newsletter = create(:newsletter)
      get edit_admin_newsletter_path(newsletter)
      assert_redirected_to root_path
      assert_equal 'You are not authorized to perform this action.', flash[:alert]
    end

    test '#update not authorized' do
      newsletter = create(:newsletter)
      patch admin_newsletter_path(newsletter), params: {
        newsletter: { title: 'Updated Title' }
      }

      assert_redirected_to root_path
      assert_equal 'You are not authorized to perform this action.', flash[:alert]
    end
  end
end

module Admin
  class NewslettersControllerTestSignedOut < ActionDispatch::IntegrationTest
    test '#index' do
      get admin_newsletters_path
      assert_redirected_to log_in_path
    end

    test '#new' do
      get new_admin_newsletter_path
      assert_redirected_to log_in_path
    end

    test '#create' do
      post admin_newsletters_path, params: {
        newsletter: { title: 'Test Newsletter', body: 'Test body content' }
      }
      assert_redirected_to log_in_path
    end

    test '#edit' do
      newsletter = create(:newsletter)
      get edit_admin_newsletter_path(newsletter)
      assert_redirected_to log_in_path
    end

    test '#update' do
      newsletter = create(:newsletter)
      patch admin_newsletter_path(newsletter), params: {
        newsletter: { title: 'Updated Title' }
      }
      assert_redirected_to log_in_path
    end
  end
end
