# frozen_string_literal: true

class AccountNavComponent < ViewComponent::Base
  def initialize(user:)
    @user = user

    super
  end
end
