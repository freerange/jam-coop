# frozen_string_literal: true

require 'test_helper'

class ErrorBoxComponentTest < ViewComponent::TestCase
  def setup
    render_inline(ErrorBoxComponent.new(title: 'Title').with_content('Content'))
  end

  def test_component_renders_title
    assert_text 'Title'
  end

  def test_component_renders_content
    assert_text 'Content'
  end
end
