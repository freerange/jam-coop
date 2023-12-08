# frozen_string_literal: true

module Renderers
  class TailwindMarkdownRenderer < Redcarpet::Render::HTML
    def header(text, level)
      classes = case level
                when 1
                  'text-4xl tracking-tight leading-10 font-extrabold mb-3'
                when 2
                  'text-3xl tracking-tight leading-10 font-bold mb-3'
                when 3
                  'text-2xl tracking-tight leading-10 font-bold mb-3'
                else
                  'text-xl tracking-tight leading-10 font-bold mb-3'
                end

      "<h#{level} class=\"#{classes}\">#{text}</h#{level}>"
    end

    def paragraph(text)
      "<p class=\"mb-3 leading-relaxed\">#{text}</p>"
    end

    def list(contents, _)
      "<ul class=\"list-disc list-inside mb-3\">#{contents}</ul>"
    end

    def block_code(code, _)
      "<pre class=\"mb-3\"><code>#{code}</code></pre>"
    end

    def link(link, _, content)
      "<a href=\"#{link}\" class=\"underline decoration-amber-600 hover:bg-amber-500\">#{content}</a>"
    end
  end
end
