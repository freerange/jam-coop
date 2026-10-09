# frozen_string_literal: true

require 'test_helper'

class ProfileLinkComponentTest < ViewComponent::TestCase
  def setup
    render_inline(
      ProfileLinkComponent.new(
        link: build(:profile_link)
      )
    )
  end

  def test_component_renders_icon
    assert_selector("img[alt='link']")
  end
end
