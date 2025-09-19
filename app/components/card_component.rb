# frozen_string_literal: true

class CardComponent < ViewComponent::Base
  def initialize(title:, subtitle:, image:)
    @title = title
    @subtitle = subtitle
    @image = image
  end
end
