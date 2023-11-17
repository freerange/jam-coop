# frozen_string_literal: true

class AddCompletedToPurchases < ActiveRecord::Migration[7.1]
  def change
    add_column :purchases, :completed, :boolean, null: false, default: false
  end
end
