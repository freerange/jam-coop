# frozen_string_literal: true

module Handlers
  class MarkdownHandler
    def call(_, source)
      markdown = Redcarpet::Markdown.new(Renderers::JamMarkdownRenderer)

      "#{markdown.render(source).inspect}.html_safe"
    end
  end
end
