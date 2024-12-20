# frozen_string_literal: true

class SidebarSectionComponent < ViewComponent::Base
  renders_one :subtitle

  def initialize(title:)
    @title = title

    super
  end
end
