# frozen_string_literal: true

module Admin
  class NewsletterPolicy < ApplicationPolicy
    class Scope < Scope
      def resolve
        if user.admin?
          scope.all
        else
          scope.none
        end
      end
    end

    def index?
      user.admin?
    end

    def new?
      user.admin?
    end

    def create?
      user.admin?
    end

    def edit?
      user.admin?
    end

    def update?
      user.admin?
    end
  end
end
