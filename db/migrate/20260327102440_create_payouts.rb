# frozen_string_literal: true

class CreatePayouts < ActiveRecord::Migration[8.1]
  def change
    create_table :payouts do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.string :payout_type, null: false
      t.string :transaction_reference, null: false
      t.string :destination_reference, null: false
      t.integer :amount_in_pence, null: false
      t.integer :platform_fee_in_pence, null: false

      t.timestamps
    end
  end
end
