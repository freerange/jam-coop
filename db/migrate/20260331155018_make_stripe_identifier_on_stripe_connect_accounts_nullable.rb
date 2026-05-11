# frozen_string_literal: true

class MakeStripeIdentifierOnStripeConnectAccountsNullable < ActiveRecord::Migration[8.1]
  def change
    change_column_null :stripe_connect_accounts, :stripe_identifier, true
  end
end
