# frozen_string_literal: true

class AddStripeSessionIdToPurchases < ActiveRecord::Migration[7.1]
  def change
    add_column :purchases, :stripe_session_id, :string
  end
end
