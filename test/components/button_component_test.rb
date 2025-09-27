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

  def test_component_renders_a_form_with_path_as_action
    assert_selector('form[action="https://example.com"]')
  end

  def test_component_adds_classes_to_default
    assert_selector('button.additional-css-class')
  end
end
