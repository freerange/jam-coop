# frozen_string_literal: true

require 'test_helper'

class ModelErrorComponentTest < ViewComponent::TestCase
  def setup
    @model = User.new
  end

  def test_component_renders_nothing_when_model_has_no_errors
    assert render_inline(ModelErrorComponent.new(model: @model)).to_html.blank?
  end

  def test_component_renders_title_model_has_errors
    @model.email = nil
    @model.save

    render_inline(ModelErrorComponent.new(model: @model))

    assert_text 'errors prohibited this user from being saved'
  end

  def test_component_renders_errors_when_model_has_errors
    @model.email = nil
    @model.save

    render_inline(ModelErrorComponent.new(model: @model))

    assert_text "Email can't be blank"
  end
end
