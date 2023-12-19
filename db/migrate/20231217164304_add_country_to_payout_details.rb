# frozen_string_literal: true

class AddCountryToPayoutDetails < ActiveRecord::Migration[7.1]
  def change
    add_column :payout_details, :country, :string
  end
end
