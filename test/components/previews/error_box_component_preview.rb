# frozen_string_literal: true

class ErrorBoxComponentPreview < ViewComponent::Preview
  def default
    render(
      ErrorBoxComponent.new(title: 'Title')
    ) do
      tag.div do
        content_tag(:span, 'Error box content')
      end
    end
  end
end
