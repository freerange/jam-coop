# frozen_string_literal: true

module ApplicationHelper
  include ActionView::Helpers::UrlHelper

  def text_link_to(*, **kwargs)
    kwargs[:class] = "#{kwargs[:class] || ''} underline decoration-amber-600 hover:bg-amber-500"
    link_to(*, **kwargs)
  end
end
