# frozen_string_literal: true

class AddStripeConnectAccountIdToPurchases < ActiveRecord::Migration[8.1]
  def change
    add_reference :purchases, :stripe_connect_account, foreign_key: true
  end
end
