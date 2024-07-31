# frozen_string_literal: true

class BoxPreview < Lookbook::Preview
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TagHelper

  def default
    render 'shared/box',
           title: 'Box title',
           action: link_to('Action Link', 'http://example.com', class: 'link') do
      content_tag(:p, 'Content')
    end
  end
end
