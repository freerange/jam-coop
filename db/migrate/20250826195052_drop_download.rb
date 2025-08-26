# frozen_string_literal: true

class DropDownload < ActiveRecord::Migration[7.2]
  def change
    drop_table :downloads do |t|
      t.integer :format
      t.references :album, null: false, foreign_key: true

      t.timestamps
    end
  end
end
