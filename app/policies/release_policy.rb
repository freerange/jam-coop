# frozen_string_literal: true

class ReleasePolicy < ApplicationPolicy
  delegate :new?, :create?, :edit?, :update?, :destroy?, to: :label_policy

  def label_policy
    @label_policy ||= LabelPolicy.new(user, record.label)
  end
end
