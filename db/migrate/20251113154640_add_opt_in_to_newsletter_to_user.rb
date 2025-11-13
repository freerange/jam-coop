# frozen_string_literal: true

class AddOptInToNewsletterToUser < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :opt_in_to_newsletter, :boolean, default: true, null: false
  end
end
