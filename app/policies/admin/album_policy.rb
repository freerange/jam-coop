# frozen_string_literal: true

module Admin
  class AlbumPolicy < ApplicationPolicy
    def index?
      user.admin?
    end
  end
end
