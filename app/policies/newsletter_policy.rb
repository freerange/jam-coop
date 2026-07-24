# frozen_string_literal: true

class NewsletterPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.published
    end
  end

  def show?
    record.published?
  end
end
