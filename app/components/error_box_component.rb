# frozen_string_literal: true

class ErrorBoxComponent < ViewComponent::Base
  def initialize(title:)
    @title = title

    super
  end
end
