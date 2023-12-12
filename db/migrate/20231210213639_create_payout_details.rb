# frozen_string_literal: true

class CreatePayoutDetails < ActiveRecord::Migration[7.1]
  def change
    create_table :payout_details do |t|
      t.string :name
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
