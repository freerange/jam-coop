# frozen_string_literal: true

module ApplicationHelper
  include ActionView::Helpers::UrlHelper
  alias original_link_to link_to

  def link_to(*, **kwargs)
    kwargs[:class] = "#{kwargs[:class] || ''} underline decoration-amber-600 hover:bg-amber-500"
    original_link_to(*, **kwargs)
  end
end
