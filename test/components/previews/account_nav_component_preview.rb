# frozen_string_literal: true

class AccountNavComponentPreview < ViewComponent::Preview
  def default
    render(
      AccountNavComponent.new(
        user: User.new
      )
    )
  end
end
