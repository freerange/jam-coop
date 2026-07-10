# frozen_string_literal: true

require 'test_helper'

class DocsControllerTest < ActionDispatch::IntegrationTest
  test 'should get about' do
    get docs_about_path
    assert_response :success
  end
end
