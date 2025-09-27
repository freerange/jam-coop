# frozen_string_literal: true

class ButtonComponent < ViewComponent::Base
  def initialize(text:, path:, **options)
    @text = text
    @path = path
    @options = options
    @additional_classes = options.slice(:class)
  end

  def classes
    default_classes = %w[p-3 bg-amber-500 hover:bg-amber-400 text-white font-medium cursor-pointer
                         disabled:bg-slate-300 disabled:cursor-not-allowed]
    default_classes << @additional_classes[:class]
    default_classes.flatten.join(' ')
  end
end
