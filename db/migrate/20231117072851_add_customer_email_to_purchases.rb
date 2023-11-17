# frozen_string_literal: true

class AddCustomerEmailToPurchases < ActiveRecord::Migration[7.1]
  def change
    add_column :purchases, :customer_email, :string
  end
end
