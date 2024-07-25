# frozen_string_literal: true

module ApplicationHelper
  include ActionView::Helpers::UrlHelper

  def text_link_to(*, **kwargs)
    kwargs[:class] = "#{kwargs[:class] || ''} underline decoration-amber-600 hover:bg-amber-500"
    link_to(*, **kwargs)
  end

  def avatar(user)
    "https://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(user.email)}?d=mp"
  end

  def card_image_url(attachment)
    return unless attachment.representable?

    cdn_url(attachment.representation(resize_to_fill: [300, 300]))
  end
end
