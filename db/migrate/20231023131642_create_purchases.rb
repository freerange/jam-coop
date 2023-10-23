# frozen_string_literal: true

class CreatePurchases < ActiveRecord::Migration[7.0]
  def change
    create_table :purchases, id: :uuid, &:timestamps
  end
end
