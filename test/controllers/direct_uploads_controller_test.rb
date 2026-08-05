# frozen_string_literal: true

require 'test_helper'

class DirectUploadsControllerTest < ActionDispatch::IntegrationTest
  test '#create responds with 200 OK when user is logged in' do
    user = create(:user)
    log_in_as(user)

    post direct_uploads_path, params: upload_params

    assert_response :success
  end

  test '#create responds with 401 Unauthorized when user is not logged in' do
    post direct_uploads_path, params: upload_params

    assert_response :unauthorized
  end

  private

  def upload_params
    {
      blob: {
        filename: 'file.wav',
        content_type: 'audio/x-wav',
        byte_size: 123,
        checksum: 'checksum'
      }
    }
  end
end
