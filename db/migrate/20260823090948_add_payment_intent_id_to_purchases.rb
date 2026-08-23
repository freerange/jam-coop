# frozen_string_literal: true

class AddPaymentIntentIdToPurchases < ActiveRecord::Migration[8.1]
  def change
    add_column :purchases, :payment_intent_id, :string
  end
end
