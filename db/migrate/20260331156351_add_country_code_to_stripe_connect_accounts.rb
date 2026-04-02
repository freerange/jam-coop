# frozen_string_literal: true

class AddCountryCodeToStripeConnectAccounts < ActiveRecord::Migration[8.1]
  def change
    add_column :stripe_connect_accounts, :country_code, :string
  end
end
