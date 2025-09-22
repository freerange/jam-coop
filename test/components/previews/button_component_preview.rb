# frozen_string_literal: true

class ButtonComponentPreview < ViewComponent::Preview
  def default
    render(
      ButtonComponent.new(
        text: 'Button text',
        path: 'http://example.com',
        method: :get
      )
    )
  end
end
