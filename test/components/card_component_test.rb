# frozen_string_literal: true

require 'test_helper'

class CardComponentTest < ViewComponent::TestCase
  def setup
    render_inline(
      CardComponent.new(
        title: 'Title',
        subtitle: 'Subtitle',
        image: 'http://example.com'
      )
    )
  end

  def test_component_renders_title
    assert_text('Title')
  end

  def test_component_renders_subtitle
    assert_text('Subtitle')
  end

  def test_component_renders_image
    assert_selector("img[src='http://example.com']")
  end
end
