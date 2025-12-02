# frozen_string_literal: true

require 'test_helper'

class LabelsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @label = create(:label)
  end

  test '#show' do
    get label_path(@label)
    assert_response :success
  end
end
