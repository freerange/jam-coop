# frozen_string_literal: true

require 'test_helper'

class CollectionControllerTestSignedIn < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    log_in_as(@user)
  end

  test '#show' do
    get collection_path
    assert_response :success
  end

  test '#show includes albums the user has purchased' do
    purchase = create(:purchase, user: @user)

    get collection_path

    assert_select 'p', purchase.album.title
  end

  test '#show indicates when the user has no purchases' do
    get collection_path

    assert_select 'p', "There's nothing in your collection at the moment."
  end
end

class CollectionControllerTestSignedOut < ActionDispatch::IntegrationTest
  test '#show' do
    get account_path
    assert_redirected_to log_in_path
  end
end
