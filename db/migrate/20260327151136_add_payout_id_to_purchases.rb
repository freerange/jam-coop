# frozen_string_literal: true

class AddPayoutIdToPurchases < ActiveRecord::Migration[8.1]
  def change
    add_reference :purchases, :payout, foreign_key: true
  end
end
