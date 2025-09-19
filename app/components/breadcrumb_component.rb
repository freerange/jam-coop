# frozen_string_literal: true

class BreadcrumbComponent < ViewComponent::Base
  def initialize(items:)
    @items = items
  end

  private

  attr_reader :items

  def breadcrumb_item(item)
    if item[:link]
      link_to item[:text], item[:link], class: 'hover:underline'
    else
      content_tag :span, item[:text], class: 'font-semibold'
    end
  end
end
