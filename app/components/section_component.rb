# frozen_string_literal: true

class SectionComponent < ViewComponent::Base
  include ApplicationHelper

  def initialize(title: nil, link_text: nil, link_path: nil)
    @title = title
    @link_text = link_text
    @link_path = link_path
  end

  def show_header?
    @title || (@link_text && @link_path)
  end
end
