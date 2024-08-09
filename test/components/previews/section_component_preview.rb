# frozen_string_literal: true

class SectionComponentPreview < ViewComponent::Preview
  def default
    render(
      SectionComponent.new(
        title: 'Title',
        link_text: 'Link Text',
        link_path: 'http://example.com'
      )
    ) do
      tag.div do
        content_tag(:span, 'Section content')
      end
    end
  end
end
