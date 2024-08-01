# frozen_string_literal: true

module TabBarHelper
  def tab_bar_item(item)
    content_tag(
      :li,
      safe_join([li_icon(item), li_content(item)]),
      class: li_class(item)
    )
  end

  private

  def li_content(item)
    if item[:link]
      link_to item[:title], item[:link]
    else
      item[:title]
    end
  end

  def li_class(item)
    'jam-tab-bar__selected' if item[:selected]
  end

  def li_icon(item)
    content_tag(:span, icon_svg.html_safe, class: 'icon') if item[:icon] # rubocop:disable Rails/OutputSafety
  end

  def icon_svg
    %(
    <svg width="0.75em" height="0.75em" viewBox="0 0 14 15" fill="none" xmlns="http://www.w3.org/2000/svg">
      <path d="M14 8.5H8V14.5H6V8.5H0V6.5H6V0.5H8V6.5H14V8.5Z" fill="#F16B7C"/>
    </svg>
    )
  end
end
