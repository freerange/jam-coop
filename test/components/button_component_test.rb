# frozen_string_literal: true

require 'test_helper'

class ButtonComponentTest < ViewComponent::TestCase
  def setup
    render_inline(
      ButtonComponent.new(
        text: 'Button',
        path: 'https://example.com',
        class: ['additional-css-class']
      )
    )
  end

  def test_component_renders_title
    assert_text('Button')
  end

  def test_component_renders_a_form_that_posts
    assert_selector('form[method="post"]')
  end

  def test_component_passes_additional_options_to_button
    render_inline(
      ButtonComponent.new(
        text: 'Button',
        path: 'https://example.com',
        method: :get
      )
    )

    assert_selector('form[method="get"]')
  end

  def test_component_renders_a_form_with_path_as_action
    assert_selector('form[action="https://example.com"]')
  end

  def test_component_adds_classes_to_default
    assert_selector('button.additional-css-class')
  end

  def test_component_can_render_a_link
    render_inline(
      ButtonComponent.new(
        text: 'Link',
        path: 'https://example.com',
        link: true,
        class: ['additional-css-class']
      )
    )

    assert_selector('a[href="https://example.com"]')
    assert_selector('a[text()="Link"]')
    assert_selector('a.additional-css-class')
  end
end
