# frozen_string_literal: true

require 'test_helper'

class TagsControllerTest < ActionDispatch::IntegrationTest
  test '#show' do
    tag = create(:tag)

    get tag_path(tag)

    assert_response :success
  end
end
