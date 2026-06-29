# frozen_string_literal: true

require 'playwright_system_test_case'

class HomeTest < PlaywrightSystemTestCase
  def setup
    @page = @playwright_page
  end

  test 'show welcome' do
    @page.goto(root_path)

    assert_includes @page.text_content('h1'), 'An online music store. Owned by us.'
  end
end
