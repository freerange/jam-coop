# frozen_string_literal: true

class CreateStripeConnectAccounts < ActiveRecord::Migration[8.1]
  def change
    create_table :stripe_connect_accounts do |t|
      t.belongs_to :user
      t.string :stripe_identifier, null: false
      t.boolean :details_submitted, default: false, null: false
      t.boolean :charges_enabled, default: false, null: false

      t.timestamps
    end

    add_index :stripe_connect_accounts, :stripe_identifier
  end
end
