# frozen_string_literal: true

class CreateEmailSubscriptionChanges < ActiveRecord::Migration[7.1]
  def change
    create_table :email_subscription_changes do |t|
      t.references :user
      t.string :message_id, null: false
      t.string :origin, null: false
      t.boolean :suppress_sending, default: false, null: false
      t.string :suppression_reason, null: false
      t.datetime :changed_at, null: false
      t.timestamps
    end
  end
end
