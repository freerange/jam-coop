# frozen_string_literal: true

class AccountNavComponent < ViewComponent::Base
  def initialize(user:)
    @user = user

    super
  end

  def active_classes
    'border-b-4 border-amber-600 -mb-[3px] font-semibold'
  end

  def inactive_classes
    'hover:border-b-4 hover:border-slate-500 hover:-mb-[3px] hover:transition-all'
  end
end
