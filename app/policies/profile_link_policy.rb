# frozen_string_literal: true

class ProfileLinkPolicy < ApplicationPolicy
  def new?
    return true if user.admin?
    return false unless user.verified?

    user.artists.include?(record.artist)
  end

  alias create? new?
  alias edit? new?
  alias update? new?
end
