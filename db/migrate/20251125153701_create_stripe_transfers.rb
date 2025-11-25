# frozen_string_literal: true

class CreateStripeTransfers < ActiveRecord::Migration[8.1]
  def change
    create_table :stripe_transfers do |t|
      t.belongs_to :stripe_account
      t.belongs_to :purchase
      t.integer :amount_in_pence, null: false

      t.timestamps
    end
  end
end
