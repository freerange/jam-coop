# frozen_string_literal: true

class ChangeCountryCodeOnStripeConnectAccountsToNotNull < ActiveRecord::Migration[8.1]
  def change
    update "UPDATE stripe_connect_accounts SET country_code = 'GB'"
    change_column_null :stripe_connect_accounts, :country_code, false
  end
end
