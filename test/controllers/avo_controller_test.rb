# frozen_string_literal: true

require 'test_helper'

class AvoControllerTestSignedInAsAdmin < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user, admin: true)
    log_in_as(@user)
  end

  test 'root' do
    get avo.root_path

    assert_redirected_to avo.resources_payout_details_path
  end
end

class AvoControllerTestSignedInAsNonAdmin < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user, admin: false)
    log_in_as(@user)
  end

  test 'root' do
    get avo.root_path

    assert_redirected_to '/'
  end
end

class AvoControllerTestSignedOut < ActionDispatch::IntegrationTest
  test 'root' do
    get avo.root_path

    assert_redirected_to '/'
  end
end
