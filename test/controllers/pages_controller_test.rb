# frozen_string_literal: true

require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  test 'should get home' do
    get root_path
    assert_response :success
  end

  test 'home should show artist of the day when there is a featured artist' do
    get root_path
    assert_not_select 'h2', text: 'Featured Artist'

    create(:artist, featured: true)

    get root_path
    assert_select 'h2', text: 'Featured Artist'
  end

  test 'should get about' do
    get about_path
    assert_response :success
  end
end
