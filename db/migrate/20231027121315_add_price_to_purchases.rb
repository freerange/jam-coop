# frozen_string_literal: true

class AddPriceToPurchases < ActiveRecord::Migration[7.1]
  def change
    add_column :purchases, :price, :decimal, precision: 8, scale: 2
  end
end
