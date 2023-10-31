# frozen_string_literal: true

class ChangeEmailSubscriptionChangesSuppressionReasonToBeNullable < ActiveRecord::Migration[7.1]
  def change
    change_column_null :email_subscription_changes, :suppression_reason, true
  end
end
