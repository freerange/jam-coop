# frozen_string_literal: true

class ModelErrorComponent < ViewComponent::Base
  def initialize(model:, model_name: nil)
    @model = model
    @model_name = model_name || model.model_name.human.downcase
  end

  def render?
    return false unless @model

    @model.errors.any?
  end
end
