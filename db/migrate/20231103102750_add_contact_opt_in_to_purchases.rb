# frozen_string_literal: true

class AddContactOptInToPurchases < ActiveRecord::Migration[7.1]
  def change
    add_column :purchases, :contact_opt_in, :boolean, default: false, null: false
  end
end
