# frozen_string_literal: true

class SectionComponent < ViewComponent::Base
  include ApplicationHelper

  def initialize(title:, link_text:, link_path:)
    @title = title
    @link_text = link_text
    @link_path = link_path

    super
  end
end
