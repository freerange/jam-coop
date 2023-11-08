# frozen_string_literal: true

class AddSendingSuppressedAtToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :sending_suppressed_at, :datetime
  end
end
