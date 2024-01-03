# frozen_string_literal: true

class AddUserToPurchase < ActiveRecord::Migration[7.1]
  def change
    add_reference :purchases, :user, foreign_key: true
  end
end
