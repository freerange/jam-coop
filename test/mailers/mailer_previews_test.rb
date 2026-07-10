# frozen_string_literal: true

require 'test_helper'

class MailerPreviewsTest < ActionDispatch::IntegrationTest
  previews = ActionMailer::Preview.all
  previews.each do |preview|
    preview.public_instance_methods(false).each do |action|
      test "#{preview.preview_name}##{action} renders OK" do
        get "/rails/mailers/#{preview.preview_name}/#{action}"

        assert_response :success
      end
    end
  end
end
