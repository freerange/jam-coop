# frozen_string_literal: true

class SectionComponent < ViewComponent::Base
  include ApplicationHelper

  def initialize(title:, link_text: nil, link_path: nil)
    @title = title
    @link_text = link_text
    @link_path = link_path

    super
  end
end
