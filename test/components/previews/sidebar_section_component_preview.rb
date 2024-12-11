# frozen_string_literal: true

class SidebarSectionComponentPreview < ViewComponent::Preview
  def default
    render(
      SidebarSectionComponent.new(
        title: 'Title',
      )
    ) do
      content_tag(:span, 'Content')
    end
  end
end
