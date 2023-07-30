# frozen_string_literal: true

require 'test_helper'

class InterestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @interest = Interest.new(email: 'chris@example.com')
  end

  test 'should get new' do
    get new_interest_url
    assert_response :success
  end

  test 'should create interest' do
    assert_difference('Interest.count') do
      post interests_url, params: { interest: { email: @interest.email } }
    end

    assert_redirected_to thankyou_url
  end
end
