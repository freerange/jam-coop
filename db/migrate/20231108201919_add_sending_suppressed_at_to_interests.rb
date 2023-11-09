# frozen_string_literal: true

class AddSendingSuppressedAtToInterests < ActiveRecord::Migration[7.1]
  def change
    add_column :interests, :sending_suppressed_at, :datetime
  end
end
