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

  def markdown(text)
    renderer = Renderers::TailwindMarkdownRenderer.new
    markdown = Redcarpet::Markdown.new(renderer)
    markdown.render(text).html_safe # rubocop:disable Rails/OutputSafety
  end

  def format_metadata(text)
    text_with_links = auto_link(text, html: { class: 'underline' }) do |t|
      t.gsub(%r{http.?://}, '')
    end
    simple_format(text_with_links, class: 'mb-2')
  end
end
