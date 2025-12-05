# frozen_string_literal: true

class CreateReleases < ActiveRecord::Migration[8.1]
  def change
    create_table :releases do |t|
      t.references :album, null: false, foreign_key: true
      t.references :label, null: false, foreign_key: true

      t.timestamps
    end
  end
end
