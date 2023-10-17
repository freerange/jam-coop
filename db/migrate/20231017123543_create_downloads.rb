# frozen_string_literal: true

class CreateDownloads < ActiveRecord::Migration[7.0]
  def change
    create_table :downloads do |t|
      t.integer :format
      t.references :album, null: false, foreign_key: true

      t.timestamps
    end
  end
end
