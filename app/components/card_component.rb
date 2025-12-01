# frozen_string_literal: true

class CardComponent < ViewComponent::Base
  def initialize(image:, title: '', subtitle: '')
    @title = title
    @subtitle = subtitle
    @image = image
  end
end
