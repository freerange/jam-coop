# frozen_string_literal: true

class ProfileLinkComponent < ViewComponent::Base
  def initialize(link:)
    @link = link
  end

  def icon
    'icons/link.svg'
  end
end
