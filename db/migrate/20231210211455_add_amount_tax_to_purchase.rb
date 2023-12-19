# frozen_string_literal: true

class AddAmountTaxToPurchase < ActiveRecord::Migration[7.1]
  def change
    add_column :purchases, :amount_tax, :integer
  end
end
