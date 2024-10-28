# frozen_string_literal: true

class ModelErrorComponentPreview < ViewComponent::Preview
  def default
    model = User.new
    model.save

    render(ModelErrorComponent.new(model:))
  end
end
