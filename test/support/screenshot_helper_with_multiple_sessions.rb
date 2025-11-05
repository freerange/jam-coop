# frozen_string_literal: true

require 'action_dispatch/system_testing/test_helpers/screenshot_helper'

module ScreenshotHelperWithMultipleSessions
  def take_failed_screenshot
    return unless failed? && supports_screenshot?

    Capybara.send(:session_pool).each do |name, session|
      showing_html = html_from_env?

      html_path = "#{prefixed_path(name)}.html"
      image_path = "#{prefixed_path(name)}.png"

      session.save_page(html_path) if showing_html
      session.save_screenshot(image_path)

      message = "[Screenshot Image]: #{image_path}\n"
      message << "[Screenshot HTML]: #{html_path}\n" if showing_html
      puts message
    end
  end

  private

  def prefixed_path(name)
    session_name = name.split(':')[1].underscore
    Rails.root.join(screenshots_dir, [session_name, image_name].join('_'))
  end
end

ActionDispatch::SystemTesting::TestHelpers::ScreenshotHelper.prepend(
  ScreenshotHelperWithMultipleSessions
)
