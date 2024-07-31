# frozen_string_literal: true

class ErrorsPreview < Lookbook::Preview
  def default
    render(
      'shared/new_errors',
      model: User.create
    )
  end
end
