# frozen_string_literal: true

class DropEmailSubscriptionChanges < ActiveRecord::Migration[7.1]
  def up
    drop_table :email_subscription_changes
  end
end
