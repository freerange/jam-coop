# frozen_string_literal: true

class AddPayoutsEnabledToStripeConnectAccounts < ActiveRecord::Migration[8.1]
  def change
    add_column :stripe_connect_accounts, :payouts_enabled, :boolean, default: false, null: false
  end
end
