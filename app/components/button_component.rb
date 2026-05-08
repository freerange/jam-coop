# frozen_string_literal: true

class ButtonComponent < ViewComponent::Base
  def initialize(text:, path:, link: false, secondary: false, **options)
    @text = text
    @path = path
    @options = options
    @link = link
    @secondary = secondary
    @additional_classes = options.slice(:class)
  end

  def classes
    default_classes =
      if @secondary
        %w[p-3 bg-white hover:bg-gray-100 text-gray-800 font-medium border border-gray-500 cursor-pointer
           disabled:bg-slate-300 disabled:cursor-not-allowed]
      else
        %w[p-3 bg-amber-500 hover:bg-amber-400 text-white font-medium cursor-pointer
           disabled:bg-slate-300 disabled:cursor-not-allowed]
      end

    default_classes << @additional_classes[:class]
    default_classes.flatten.join(' ')
  end
end
