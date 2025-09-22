# frozen_string_literal: true

class ButtonComponent < ViewComponent::Base
  def initialize(text:, path:, **options)
    @text = text
    @path = path
    @options = options
  end

  def classes
    'w-full py-3 bg-amber-500 hover:bg-amber-400 text-white
      font-medium cursor-pointer disabled:bg-slate-300 disabled:cursor-not-allowed'
  end
end
