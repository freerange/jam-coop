# frozen_string_literal: true

class AddStripeConnectEnabledToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :stripe_connect_enabled, :boolean, default: false

    update 'UPDATE users SET stripe_connect_enabled = FALSE'

    change_column_null :users, :stripe_connect_enabled, false
  end
end
