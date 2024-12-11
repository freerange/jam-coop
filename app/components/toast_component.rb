# frozen_string_literal: true

class ToastComponent < ViewComponent::Base
  def initialize(message:, type:)
    @message = message
    @type = type

    super
  end

  def type_class
    @type == :notice ? 'border-blue-600' : 'border-red-600'
  end

  def render?
    @message
  end
end
