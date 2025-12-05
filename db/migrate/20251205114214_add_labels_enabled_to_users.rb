# frozen_string_literal: true

class AddLabelsEnabledToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :labels_enabled, :boolean, default: false, null: false
  end
end
