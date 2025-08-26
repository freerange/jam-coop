# frozen_string_literal: true

class CreatePurchaseDownloads < ActiveRecord::Migration[7.2]
  def change
    create_table :purchase_downloads do |t|
      t.integer :format
      t.references :purchase, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
