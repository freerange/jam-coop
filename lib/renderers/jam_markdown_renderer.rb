# frozen_string_literal: true

module Renderers
  class JamMarkdownRenderer < Redcarpet::Render::HTML
    def header(text, level)
      case level
      when 1
        "<section class=\"jam-box box\"> <div class=\"jam-box__header\"> <h1>#{text}</h1> </div>"
      else
        "<h#{level}>#{text}</h#{level}>"
      end
    end

    def doc_footer
      '</section>'
    end

    def link(link, _, content)
      "<a href=\"#{link}\" class=\"link\">#{content}</a>"
    end
  end
end
