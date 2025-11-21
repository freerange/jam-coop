# frozen_string_literal: true

require 'test_helper'

class ActivitiesControllerTest < ActionDispatch::IntegrationTest
  test '#show redirects to login if no user logged in' do
    get activity_path

    assert_redirected_to log_in_path
  end

  test '#show renders' do
    user = create(:user)
    log_in_as(user)

    get activity_path

    assert_response :success
  end
end
