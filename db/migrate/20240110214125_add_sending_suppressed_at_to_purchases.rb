# frozen_string_literal: true

class AddSendingSuppressedAtToPurchases < ActiveRecord::Migration[7.1]
  def change
    add_column :purchases, :sending_suppressed_at, :datetime
  end
end
