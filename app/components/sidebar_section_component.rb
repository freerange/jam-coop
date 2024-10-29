# frozen_string_literal: true

class SidebarSectionComponent < ViewComponent::Base
  def initialize(title:)
    @title = title

    super
  end
end
