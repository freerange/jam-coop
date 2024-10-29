# frozen_string_literal: true

class ModelErrorComponent < ViewComponent::Base
  def initialize(model:)
    @model = model

    super
  end

  def render?
    return false unless @model

    @model.errors.any?
  end
end
